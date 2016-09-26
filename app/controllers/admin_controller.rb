class AdminController < ApplicationController

  before_filter :check_session
  before_filter :admin_session
  def new
    @user = User.new
    @action = "create"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_index_path
    else
      render 'new'
    end
  end

  def edit
      @user = User.find_by_id(params[:id])
      @action = "update"
      if @user.blank?
        redirect_to root_path
        flash[:notice] = "No user Present"
      end
  end

  def update
    @user = User.find_by_id(params[:id])

    if !@user.blank?
      @user.update(user_params)
      flash[:notice] = "Updated Succesfully"
      redirect_to admin_index_path
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
