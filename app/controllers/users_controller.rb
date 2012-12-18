class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, :delete_admin?, only: :destroy

  # because of correct_user, @user is already defined
  # don't need @user in edit, n' update anymore

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

  def new
    if signed_in?
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
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
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted"
    redirect_to users_url
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  # these will be called before edit, update (before_filter)
  #q where to put private
  private
    def signed_in_user
      unless signed_in?
        #r 9.2.3 friendly forwarding
        # store the location in order to redirect back after signed in
        stored_location

        # redirect_to signin_url, notice: "Please sign in." unless signed_in?
        redirect_to signin_url
        flash[:notice] = "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    # 9.6.9 admin cannot delete self n' other admin
    def delete_admin?
      del_user = User.find(params[:id])
      unless !del_user.admin?
        flash[:error] = "Admin user cannot be deleted"
        # redirect_to root_url
        redirect_to root_path
      end
    end
end
