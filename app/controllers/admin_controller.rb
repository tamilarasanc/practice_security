class AdminController < ApplicationController

  before_filter :check_session
  before_filter :admin_session
  def new
    @user = User.new
  end

  def create
    @user = User.create_user(user_params)

    if @user
      redirect_to admin_index_path
      if params[:user][:admin]
      flash[:notice] = "Admin creates a user and given admin access"
      else
        flash[:notice] = "normal user created by admin successfully"
      end
    else
      redirect_to :action => 'new'
    end
  end

  def edit
      @user = User.find_by_id(params[:id])
      if @user.blank?
        redirect_to root_path
        flash[:notice] = "No user Present"
      end
  end

  def update
    @user = User.find_by_id(params[:id])
    if !@user.blank?
      @user.update_user(user_params)
      redirect_to admin_index_path
      flash[:notice] = "Updated Succesfully"
    else
      render 'edit'
    end
  end


  def show
    @user = User.find_by_id(params[:id])
    if  @user.blank?
      redirect_to root_path
      flash[:notice] = "No user Present"
    end
  end

  def index
    @users = User.all
  end

  def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "User Deleted Successfully"
    redirect_to admin_index_path
  end

  def add_admin_or_remove_admin
    debugger
    @user = User.find(params[:user_id])
    if @user.admin == true
      @user.update_attributes(:admin => false)
      render :text => "Add Admin"
    else
      @user.update_attributes(:admin => true)
      render :text => "Remove Admin"
    end

  end

  private
  def user_params
      params.require(:user).permit(:name,:password,:email,:description,:admin)
  end

end
