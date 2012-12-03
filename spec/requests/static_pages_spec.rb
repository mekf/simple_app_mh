require 'spec_helper'

describe "StaticPages" do

	#check http://ruby.railstutorial.org/chapters/filling-in-the-layout#sec-pretty_rspec
	#listing 5.2.6
	#let(:base_title) {"Ruby on Rails Tutorial Sample App"}

	subject { page }
	
	describe "Home page" do
		before { visit root_path }
		
		it { should have_selector('h1', text: "Sample App") }
		it { should have_selector('title', text: full_title('')) }
		#getting full_title from spec/support

		#it { should have_selector('title', text: "#{base_title}") }
		#it { should_not have_selector('title', text: '| Home') }

	end

	describe "Help page" do
		before { visit help_path }
		
		it { should have_selector('h1', text: "Help") }
		it { should have_selector('title', text: full_title('Help')) }

	end
	
	describe "About page" do
		before { visit about_path }

		it { should have_selector('h1', text: "About") }
		it { should have_selector('title', text: full_title('About')) }

	end

	describe "Contact page" do
		before { visit contact_path }

		it { should have_selector('h1', text: "Contact") }
		it { should have_selector('title', text: full_title('Contact')) }
		
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