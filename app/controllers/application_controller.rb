# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def user_id_in_session
    session[:user_id]
  end
  
  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
