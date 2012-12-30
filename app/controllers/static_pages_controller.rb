class StaticPagesController < ApplicationController
  def home
  	@title = 'Home'
    @micropost = current_user.microposts.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end

  def misc
  end
end
