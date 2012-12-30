class UsersController < ApplicationController
  before_filter :signed_in_user?, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user?, only: [:edit, :update]
  before_filter :admin_user?, :admin_self_delete?, only: :destroy

  # because of correct_user, @user is already defined
  # don't need @user in edit, n' update anymore

  def troll
  end

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

  def new
    if signed_in? #sessions_helper
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def create
    if signed_in? #sessions_helper
      redirect_to root_url
    else
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render "new"
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    # 9.6.9 admin cannot delete self
    if admin_self_delete?
      flash[:error] = "Cannot delete own admin account!"
      redirect_to root_url
    else
      @del_user.destroy
      flash[:success] = "User has been deleted"
      redirect_to users_url
    end

    # del_user = User.find(params[:id])
    # if (current_user == del_user) && (current_user.admin?)
    #   flash[:error] = "Cannot delete own admin account!"
    #   redirect_to root_url
    # else
    #   del_user.destroy
    #   flash[:success] = "User has been deleted"
    #   redirect_to users_url
    # end
  end

  #q why private
  private
    # listing 10.27 | moving to session_helper
    # because we also need this one for 2 controllers: Users n' Microposts
    
    # def signed_in_user?
    #   unless signed_in?
    #     #r 9.2.3 friendly forwarding
    #     # store the location in order to redirect back after signed in
    #     stored_location

    #     # redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #     redirect_to signin_url
    #     flash[:notice] = "Please sign in."
    #   end
    # end

    def correct_user?
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user?
      redirect_to(root_path) unless current_user.admin?
    end

    # 9.6.9 admin cannot delete self
    def admin_self_delete?
      @del_user = User.find(params[:id])
      current_user == @del_user && current_user.admin?
    end
end
