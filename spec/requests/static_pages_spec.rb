require 'spec_helper'

describe "StaticPages" do

	#check http://ruby.railstutorial.org/chapters/filling-in-the-layout#sec-pretty_rspec
	#listing 5.2.6
	#let(:base_title) {"Ruby on Rails Tutorial Sample App"}

	subject { page }
	
	shared_examples "all static pages" do
		it { should have_selector('h1', text: heading) }
		it { should have_selector('title', text: full_title(page_title)) }
	end

	describe "Home page" do
		before { visit root_path }
		let(:heading)	{ 'Sample App' }
		let(:page_title) { '' }

		it_should_behave_like "all static pages"
		it { should_not have_selector('title', text: '| Home') }

		#redundant since 5.35
		# it { should have_selector('h1', text: "Sample App") }
		# it { should have_selector('title', text: full_title('')) }
		#getting full_title from spec/support

		#redundant since 5.27
		#it { should have_selector('title', text: "#{base_title}") }
		#it { should_not have_selector('title', text: '| Home') }
	end

	describe "Help page" do
		before { visit help_path }
		let(:heading) { 'Help' }
		let(:page_title) { 'Help' }

		it_should_behave_like "all static pages"
	end
	
	describe "About page" do
		before { visit about_path }
		let(:heading) { 'About Us' }
		let(:page_title) { 'About Us' }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }
		let(:heading) { 'Contact' }
		let(:page_title) { 'Contact' }

		it_should_behave_like "all static pages"
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