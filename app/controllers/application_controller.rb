require 'bigbluebutton_api'

class ApplicationController < ActionController::Base

  def bbb_server
    @bbb_server ||= BigBlueButton::BigBlueButtonApi.new(
      Rails.configuration.bigbluebutton_endpoint,
      Rails.configuration.bigbluebutton_secret, "0.8")
  end

end
