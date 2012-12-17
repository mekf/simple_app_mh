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
    describe "NON-signed-in-user interactions in the Users controller" do

      describe "visiting the edit page" do
        before { visit edit_user_path(@regd_user) }
        it { should have_selector('title', text: 'Sign In') }
      end

      describe "submitting to the update action" do
        before { put user_path(@regd_user) }
        it { response.should redirect_to(signin_path) }
      end
    end
  end
end
