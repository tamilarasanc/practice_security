class LoginController < ApplicationController
  before_filter :check_session,:except => [:login,:verify_login]


  def login

  end

  def verify_login
    @user = User.where("email =? and password =?",params[:email],params[:password]).last
    if !@user.blank?
      if @user.admin == true
         redirect_to admin_index_path
        session[:user_id] = @user.id
         session[:role] = @user.admin
         flash[:notice] = "Logged in as  Administrator#{@user.name} , you can edit , vied and modify others profile"
      else
        session[:user_id] = @user.id
        redirect_to show_user_path(session[:user_id])
        flash[:notice] = "Logged in as #{@user.name},you can only view and edit profile of yours"
      end
    else
      flash[:notice] = "No User"
      redirect_to :action => 'login'
    end

  end

  def no_method
     render 404
  end

  def logout
    reset_session
    redirect_to :action => 'login'
  end

end
