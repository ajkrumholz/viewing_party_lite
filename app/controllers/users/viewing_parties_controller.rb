# frozen_string_literal: true

module Users
  class ViewingPartiesController < ApplicationController
    def new
      @host = User.find(user_id_in_session)
      @friends = @host.friends
      @movie = MoviesFacade.details(params[:movie_id])
    end

    def create
      host = User.find(user_id_in_session)
      invitees = User.invited_users(params[:users])
      viewing_party = ViewingParty.new(viewing_party_params)
      if params[:duration] >= params[:movie_duration]
        if viewing_party.save
          host.viewing_parties << viewing_party
          host.set_host(viewing_party)
          invitees.each do |invitee|
            invitee.viewing_parties << viewing_party
          end
          redirect_to user_path(host)
        else
          redirect_to new_user_movie_viewing_party_path(params[:movie_id])
          flash[:alert] = "Error: #{error_message(viewing_party.errors)}"
        end
      else
        redirect_to new_user_movie_viewing_party_path(params[:movie_id])
        flash[:alert] = 'Error: Duration cannot be shorter than movie runtime'
      end
    end

    private

    def viewing_party_params
      params.permit(:duration, :start_time, :movie_id, :movie_title, :host_id)
    end
  end
end
