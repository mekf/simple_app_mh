require 'spec_helper'
# get the Matcher: have_error_message, have_success_message from utilities.rb

describe "User Pages" do

  subject { page }

  shared_examples_for "All User Pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(title)) }
  end

  describe "Sign Up Page" do
    before { visit signup_path }
    let(:heading) { 'Sign Up' }
    let(:title) { 'Sign Up' }

    it_should_behave_like "All User Pages"
  end

  describe "signup process" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        let(:heading) { 'Sign Up' }
        let(:title) { 'Sign Up' }
        before { click_button submit }

        it_should_behave_like "All User Pages"
        it { should have_content('error' )}
      end
    end

    describe "with valid information" do
      before do
        @user = FactoryGirl.build(:user)
        fill_in "Name", with: @user.name
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        fill_in "Confirmation", with: @user.password_confirmation
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email(@user.email) }
        let(:heading) { user.name }
        let(:title) { user.name }

        it_should_behave_like "All User Pages"
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out', href: signout_path) }
      end
    end
  end

  describe "Profile Page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    let(:heading) { user.name }
    let(:title) { user.name }

    it_should_behave_like "All User Pages"
  end
end
