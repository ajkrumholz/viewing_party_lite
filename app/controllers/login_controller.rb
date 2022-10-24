class LoginController < ApplicationController

  def index

  end

  def create
    user = User.find_by(username: params[:username])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:alert] = "Welcome back, #{user.username}!"
      redirect_to user_path(user)
    else
      flash[:alert] = "Incorrect password, please try again"
      render :index
    end
  end
end