#check http://ruby.railstutorial.org/chapters/filling-in-the-layout#sec-pretty_rspec
#listing 5.2.6

def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample App"
  	if page_title.empty?
    	base_title
  	else
    	"#{base_title} | #{page_title}"
	end
end

def invalid_emails(addresses)
  addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                 foo@bar_baz.com foo@bar+baz.com]
end

def valid_emails(addresses)
  addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
end

def filled_valid_signin_info(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button 'Sign in'
  #sign in when not using Capybara, Listing 9.6
  cookies[:remember_token] = user.remember_token
end

def fill_valid_info(user)
  fill_in "Name", with: user.name
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  fill_in "Confirm Password", with: user.password_confirmation
end

# use this after before_filter signed_in_user is created
# it's required for the specs of users_pages_spec to pass
def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |msg|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: msg)
  end
end

RSpec::Matchers.define :have_success_message do |msg|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: msg)
  end
end