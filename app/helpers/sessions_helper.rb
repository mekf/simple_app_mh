module SessionsHelper

  def sign_in(user)
    # cookies[:remember_token] = { value: user.remember_token
    #                              expires: 20.years.from_now.utc }

    #More elegant solution
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in_user?
    unless signed_in?
      #r 9.2.3 friendly forwarding
      # store the location in order to redirect back after signed in
      stored_location

      # redirect_to signin_url, notice: "Please sign in." unless signed_in?
      redirect_to signin_url
      flash[:notice] = "Please sign in."
    end
  end

  #r 9.2.3 friendly forwarding
  def stored_location
    session[:return_to] = request.url
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
end
