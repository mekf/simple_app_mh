module ApplicationHelper
	# http://ruby.railstutorial.org/chapters/rails-flavored-ruby#top 4.2
	# Returns full title and | depending on the value provided
	def full_title(page_title)
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
