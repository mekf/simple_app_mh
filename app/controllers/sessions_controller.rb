class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user

      #r 9.2.3 friendly forwarding
      redirect_back_or user
    else
      #not quite right!
      #flash[:error] = 'Invalid email/password combination'

      #flash.now dies as soon as there's another request
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
