# frozen_string_literal: true

module Users
  class DiscoverController < ApplicationController
    def index
      @user = User.find(user_id_in_session)
    end
  end
end
