class LoginController < ApplicationController
  before_filter :check_session,:except => [:login,:verify_login]


  def login

  end

  def verify_login
    @user = User.where("email =? and password =?",params[:email],params[:password]).last
    if !@user.blank?
      if @user.admin == true
         redirect_to users_path
        session[:user_id] = @user.id
         session[:role] = @user.admin
         flash[:notice] = "Logged in as  Administrator#{@user.name} , you can edit , vied and modify others profile"
      else
        flash[:notice] = "You are not admin"
        session[:user_id] = @user.id
        redirect_to user_path(session[:user_id])
        flash[:notice] = "Logged in as #{@user.name},you can only view and edit profile of yours"
      end
    else
      flash[:notice] = "No User"
      redirect_to :action => 'login'
    end

  end

  def logout
    reset_session
    redirect_to :action => 'login'
  end

end
