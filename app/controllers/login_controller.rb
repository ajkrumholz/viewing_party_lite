class LoginController < ApplicationController

  def index

  end

  def create
    user = User.find_by(username: params[:username])
    if user.present?
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:alert] = "Welcome back, #{user.username}!"
        redirect_to user_path(user)
      else
        flash[:alert] = "Incorrect password, please try again"
        render :index
      end
    else
      flash[:alert] = "Incorrect username, please try again, or create a new account"
      render :index
    end
  end

  def destroy
    session.delete(user_id_in_session)
    flash[:alert] = "You have successfully logged out"
    redirect_to root_path
  end
end