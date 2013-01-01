require 'spec_helper'
# get the Matcher: have_error_message, have_success_message from utilities.rb

describe "Authentication" do

  subject { page }
  before { @regd_user = FactoryGirl.create(:user) }

  shared_examples_for "Authentication Page" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(title)) }
  end

  describe "Signin Page" do
    before { visit signin_path }
    let(:heading) { 'Sign In' }
    let(:title) { 'Sign In' }

    it_should_behave_like "Authentication Page"
  end

#$ SIGN IN PROCESS
  describe "signin process" do
    before { visit signin_path }
    let(:submit) { 'Sign in' }

    describe "with invalid information" do
      let(:heading) { 'Sign In' }
      let(:title) { 'Sign In' }
      before { click_button submit }

      it_should_behave_like "Authentication Page"
      it { should have_error_message('Invalid') }

      describe "after visiting another page" do
        before { click_link 'Home' }

        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid information" do
      before { filled_valid_signin_info(@regd_user) } #utilities.rb

      it { should have_selector('title', text: @regd_user.name) }

      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(@regd_user)) }
      it { should have_link('Settings', href: edit_user_path(@regd_user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "after sign out" do
        before { click_link 'Sign out' }
        it { should have_link('Sign in', href: signin_path) }
        it { should_not have_link('Sign out', href: signout_path) }
      end
    end
  end
#! SIGN IN PROCESS ENDS

  describe "authorization" do
    # check for signed_in_user in users_controller
    describe "NON-signed-in-user n' Users controller" do

      describe "visiting the following page" do
        before { visit following_user_path(@regd_user) }
        it { should have_selector('title', text: 'Sign In') }
      end

      describe "visiting the followers page" do
        before { visit followers_user_path(@regd_user) }
        it { should have_selector('title', text: 'Sign In') }
      end

      describe "visiting Users#edit page" do
        before { visit edit_user_path(@regd_user) }
        it { should have_selector('title', text: 'Sign In') }

        describe "after signing in" do
          before { filled_valid_signin_info(@regd_user) }

          it "should render the proper Users#edit page" do
            page.should have_selector('title', text: 'Edit user')
          end

          # check for 9.2.3 friendly forwarding
          describe "no further redirection" do
            before { visit edit_user_path(@regd_user) }
            it { should have_selector('title', text: 'Edit user') }
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              filled_valid_signin_info(@regd_user)
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: @regd_user.name)
            end
          end
          # check for 9.2.3 friendly forwarding ENDS
        end
      end

      describe "submitting a PUT req to Users#update action" do
        before { put user_path(@regd_user) }
        it { response.should redirect_to(signin_path) }
      end

      describe "visitting Users#index page" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign In') }
      end
    end

    # check for correct_user in users_controller
    describe "messing with diff user's stuffs" do
      let(:diff_user) { FactoryGirl.create(:user) }
      before { sign_in @regd_user }

      describe "visitting Users#edit page" do
        before { visit edit_user_path(diff_user)}
        it { should_not have_selector('title', text: "Edit user")}
      end

      describe "submitting a PUT req to Users#update action" do
        before { put user_path(diff_user) }
        it { response.should redirect_to(root_path) }
      end
    end

    describe "NON-signed-in-user n' Microposts controller" do
      describe "submitting to the create action" do
        before { post microposts_path }
        specify { response.should redirect_to(signin_path) }
      end

      describe "submitting to the destroy action" do
        before { delete micropost_path(FactoryGirl.create(:micropost)) }
        specify { response.should redirect_to(signin_path) }
      end
    end
  end
end
