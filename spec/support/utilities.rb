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

def fill_valid_info(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button 'Sign in'
end