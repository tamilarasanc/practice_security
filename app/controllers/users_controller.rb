class UsersController < ApplicationController

   before_filter :check_session
   before_filter :admin_session, :only => [:new,:create,:index,:destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    redirect_to users_path
    else
    render 'new'
    end
  end

  def edit
    if session[:user_id] == params[:id].to_i || session[:role]
    @user = User.find(params[:id])
    else
    redirect_to root_path
    flash[:notice] = "you are not authorised to edit others profile"
    end
  end

   def update
     @user = User.find_by_id(params[:id])

     if !@user.blank? and @user.update(user_params)
       redirect_to users_path
     else
       render 'edit'
     end
   end


  def show
    @user = User.find_by_id(params[:id])
    if  !@user.blank?
      if session[:role]  || session[:user_id] == @user.id
      else
        redirect_to root_path
        flash[:notice] = "You are not authorised or normal user to view Profile"
      end
    else
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
    redirect_to users_path

  end

  private
  def user_params
    if session[:user_id] and session[:role]
    params.require(:user).permit(:name,:password,:email,:description,:admin)
    else
      params.require(:user).permit(:name,:password,:email,:description)
    end
  end
end
