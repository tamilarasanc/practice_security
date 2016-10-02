class UsersController < ApplicationController

     before_filter :check_session

  def edit
    @user = User.find_by_id(params[:id])
    if  !@user.blank?
     if session[:user_id] == params[:id].to_i
    else
    redirect_to root_path
    flash[:notice] = "you are not authorised to edit others profile"
    end
    else
    flash[:notice] = "No User Present"
    redirect_to root_path
    end
  end

   def update
     @user = User.find_by_id(params[:id])
     if !@user.blank?
       @user.update_user(user_params)
       if session[:user_id] == @user.id
       flash[:notice] = "Succesfully updated"
       redirect_to show_user_path
       end
     else
       flash[:notice] = "No Proper User Data to update"
       redirect_to root_path
      end
   end


  def show
    @user = User.find_by_id(params[:id])
    if  !@user.blank?
      if session[:user_id] == @user.id
      else
        redirect_to root_path
        flash[:notice] = "You are not authorised or normal user to view Profile"
      end
    else
      redirect_to root_path
        flash[:notice] = "No user Present"
    end
  end

   def change_password
     @user = User.find_by_id(params[:id])
     if  !@user.blank?
       if session[:user_id] != @user.id

         redirect_to root_path
         flash[:notice] = "You are not authorised or update users password"
       end
     else
       redirect_to root_path
       flash[:notice] = "No user Present"
     end

   end

     def update_password

       @user = User.find_by_id(params[:id])
       if  !@user.blank?
         if session[:user_id] != @user.id
           redirect_to root_path
           flash[:notice] = "You are not authorised to update users password"
         elsif @user.password == params[:exist_password]
             if params[:new_password] == params[:confirm_password]
               @user.update_password(params[:new_password])
                   flash[:notice] = "Password updated succesfully"
               redirect_to show_user_path
             else
               flash[:notice] = "new password and confirm password is not matching"
               redirect_to change_password_path
             end
           else
             flash[:notice] = "old password is not matching"
             redirect_to change_password_path
             end
       else
         redirect_to root_path
         flash[:notice] = "No user Present"
       end

     end


  private
  def user_params
      params.require(:user).permit(:name,:password,:email,:description)
    end
end
