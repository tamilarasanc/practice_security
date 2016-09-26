class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def check_session
    if !session[:user_id].blank?
      user = User.find_by_id(session[:user_id])
     if user.id != session[:user_id]
      redirect_to root_path
      flash[:notice] = "No user Present"
     end
    else
      redirect_to root_path
      flash[:notice] = "Login First"
    end
  end


  def admin_session
    if session[:role]
      user = User.find_by_id(session[:user_id])
      if user.blank?
      redirect_to root_path
      flash[:notice] = "No user Present"
      end
      else
      redirect_to root_path
      flash[:notice] = "you are not admin"
    end
  end


end
