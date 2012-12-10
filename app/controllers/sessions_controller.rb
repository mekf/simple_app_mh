class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # correct sign in
    else
      #not quite right!
      #flash[:error] = 'Invalid email/password combination'

      #flash.now dies as soon as there's another request
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end
