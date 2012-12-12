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
end

def fill_valid_signup_info(user)
  fill_in "Name", with: user.name
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  fill_in "Confirmation", with: user.password_confirmation
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