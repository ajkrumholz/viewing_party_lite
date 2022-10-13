class Users::ViewingPartiesController < ApplicationController
  def new
    @users = User.all
    @user = User.find(params[:user_id]) 
    @movie = MoviesFacade.details(params[:movie_id])
  end

  def create
    @user = User.find(params[:user_id])
  end
end