# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    if user_id_in_session
      @user = User.find(user_id_in_session)
      @image_url_hash = MoviesFacade.images(@user.movie_ids)
    else
      flash[:alert] = "You do not have permission to access this page, please log in or create an account"
      redirect_to root_path
    end
  end

  def new

  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user)
      flash[:alert] = "Welcome #{user.username}!"
    else
      redirect_to register_path
      flash[:alert] = "Error: #{error_message(user.errors)}"
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :email)
  end
end
