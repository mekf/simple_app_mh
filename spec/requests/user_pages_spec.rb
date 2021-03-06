require 'spec_helper'
# get the Matcher: have_error_message, have_success_message from utilities.rb

describe "User Pages" do

  subject { page }

  # need to sign_in because of the authorization process
  # check before_filter in users_controller
  before do
    @regd_user = FactoryGirl.create(:user, email: 'regd_user@example.org')
    @admin = FactoryGirl.create(:admin)
  end

  shared_examples_for "All User Pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(title)) }
  end

  describe "Troll Page" do
    before do
      visit troll_path
    end
    let(:heading) { 'Troll Troll Troll Troll Troll' }
    let(:title) { 'Troll Troll Troll Troll Troll' }

    it_should_behave_like "All User Pages"
    # specify { response.should have_tag("img") }
    it { should have_selector('img', alt: 'Troll') }
  end

  describe "NON sign-in user" do
    it "should not have profile, n' edit links" do
      page.should_not have_link('Profile')
      page.should_not have_link('Settings')
    end
  end

  describe "Index Page" do
    before(:each) do
      sign_in @regd_user
      visit users_path
    end
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    let(:title) { 'All Users' }
    let(:heading) { 'All Users' }

    it_should_behave_like "All User Pages"

    describe "pagination" do
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete process" do
      it "normal user should have no del_link" do
        page.should_not have_link('delete', href: user_path(User.first))
      end

      describe "as Admin user" do
        #q where to put let
        before do
          sign_in @admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should delete the user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it "should not visible to admin" do
          page.should_not have_link('delete', href: user_path(@admin))
        end

        # 9.6.9 admin cannot delete self
        describe "cannot delete self by DELETE request" do
          before { delete user_path(@admin) }

          it { response.should redirect_to(root_url) }
          it { response.should_not redirect_to(users_path) }
          specify { response.should redirect_to(root_url),
                    flash[:error].should =~ /Cannot delete own admin account!/i }

          #q Capybara doesn't direct?
          #q specify?
          # it { should have_error_message('Cannot delete own admin account!') }
          # it { should have_content('Cannot delete own admin account!') }
        end
      end
    end
  end

  describe "Profile Page" do
    let!(:msg1) { FactoryGirl.create(:micropost, user: @regd_user) }
    let!(:msg2) { FactoryGirl.create(:micropost, user: @regd_user) }

    before { visit user_path(@regd_user) }

    let(:heading) { @regd_user.name }
    let(:title) { @regd_user.name }

    it_should_behave_like "All User Pages"
    it { should have_content(msg1.content) }
    it { should have_content(msg2.content) }
    it { should have_content(@regd_user.microposts.count) }

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in @regd_user }

      describe "following user" do
        before { visit user_path(other_user) }

        it "should increase the followed count" do
          expect do
            click_button "Follow"
          end.to change(@regd_user.followed_users, :count).by(1)
        end

        it "should increase the other_user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing user" do
        before do
          @regd_user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrease the followed count" do
          expect do
            click_button "Unfollow"
          end.to change(@regd_user.followed_users, :count).by(-1)
        end

        it "should decrease the other_user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        
        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end
  end

#$ SIGN UP STARTS
  describe "Sign Up Page" do
    before { visit signup_path }
    let(:heading) { 'Sign Up' }
    let(:title) { 'Sign Up' }

    it_should_behave_like "All User Pages"
  end

  describe "signup process" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "already signed in" do
      before do
        sign_in @regd_user
        visit signup_path
      end

      describe "should be redirected to the root_url" do
        it { should_not have_content('Create my account') }
        it { should_not have_selector('title', text: ' | ') }
        # it { should have_selector('h1', text: 'Sample App') }
        # broken as home now have if-else
      end
    end

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        let(:heading) { 'Sign Up' }
        let(:title) { 'Sign Up' }
        before { click_button submit }

        it_should_behave_like "All User Pages"
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        @signup_user = FactoryGirl.build(:user)
        fill_valid_info(@signup_user) #utilities.rb
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email(@signup_user.email) }
        let(:heading) { user.name }
        let(:title) { user.name }

        it_should_behave_like "All User Pages"
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out', href: signout_path) }
      end
    end
  end
#! SIGN UP ENDS

#$ EDIT STARTS
  describe "Edit Page" do
    before do
      sign_in @regd_user
      visit edit_user_path(@regd_user)
    end

    let(:heading) { 'Update your profile' }
    let(:title) { 'Edit user' }

    it_should_behave_like "All User Pages"
    it { should have_link('change', href: 'http://gravatar.com/emails') }
  end

  describe "edit process" do
    let(:submit) { 'Save changes' }
    before do
      sign_in @regd_user
      visit edit_user_path(@regd_user)
    end

    describe "with invalid information" do
      before { click_button submit }

      it { should have_error_message('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new-email@example.com" }
      before do
        @regd_user.name = new_name
        @regd_user.email = new_email
        fill_valid_info(@regd_user)
        click_button submit
      end

      let(:heading) { new_name }
      let(:title) { new_name }

      it_should_behave_like "All User Pages"
      it { should have_success_message('updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { @regd_user.reload.name.should == new_name }
      specify { @regd_user.reload.email.should == new_email }
    end
  end
#! EDIT ENDS

  describe "following/followers" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { @regd_user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in @regd_user
        visit following_user_path(@regd_user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(@regd_user.name, href: user_path(@regd_user)) }
    end
  end
end