require 'spec_helper'

describe "Static Pages" do

	#check http://ruby.railstutorial.org/chapters/filling-in-the-layout#sec-pretty_rspec
	#listing 5.2.6
	#let(:base_title) {"Ruby on Rails Tutorial Sample App"}

	subject { page }

	shared_examples_for "All Static Pages" do
		it { should have_selector('h1', text: heading) }
		it { should have_selector('title', text: full_title(page_title)) }
	end

	it "links on root path" do
		visit root_path
		click_link 'Sample App'
			page.should have_selector('title', text: full_title(''))
		click_link 'Home'
			page.should have_selector('title', text: full_title(''))
		click_link 'Help'
			page.should have_selector('title', text: full_title('Help'))
		click_link 'About'
			page.should have_selector('title', text: full_title('About Us'))
		click_link 'Contact'
			page.should have_selector('title', text: full_title('Contact'))
	end

	describe "Home page" do
		before { visit root_path }
		let(:heading)	{ 'Sample App' }
		let(:page_title) { '' }

		it_should_behave_like "All Static Pages"
		it { should_not have_selector('title', text: '| Home') }

		describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "relationship status" do
      	let(:other_user) { FactoryGirl.create(:user) }
      	before do
      		user.follow!(other_user)
      		visit root_path
      	end

      	it { should have_link("0 follower", href: followers_user_path(user)) }
      	it { should have_link("1 following", href: following_user_path(user)) }
      end
    end
	end

	describe "Help page" do
		before { visit help_path }
		let(:heading) { 'Help' }
		let(:page_title) { 'Help' }

		it_should_behave_like "All Static Pages"
	end

	describe "About page" do
		before { visit about_path }
		let(:heading) { 'About Us' }
		let(:page_title) { 'About Us' }

		it_should_behave_like "All Static Pages"
	end

	describe "Contact page" do
		before { visit contact_path }
		let(:heading) { 'Contact' }
		let(:page_title) { 'Contact' }

		it_should_behave_like "All Static Pages"
	end

	describe "MISC Home Old page" do
		before { visit misc_path }

		it "should have the escaped variable '= @title'" do
			page.should have_content('= @title')
		end
		it "should have hash style NEW" do
			page.should have_selector('a', text: '| new')
		end
		it "should have hash style OLD" do
			page.should have_selector('a', :text => '| old')
		end
	end
end