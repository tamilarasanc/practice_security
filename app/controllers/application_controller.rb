class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def check_session
    if !session[:user_id].blank?
      flash[:notice] = "Logged in as #{User.find_by_id(session[:user_id]).name}"
    else
      redirect_to root_path
      flash[:notice] = "Login First"
    end
  end


  def admin_session
    if session[:user_id] and session[:role]
      flash[:notice] = "Logged in as  Administrator#{User.find_by_id(session[:user_id])}"
     else
      redirect_to root_path
      flash[:notice] = "you are not admin"
    end
  end


end
