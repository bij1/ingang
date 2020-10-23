require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ingang
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Default credentials (test-install.blindsidenetworks.com/bigbluebutton).
    config.bigbluebutton_endpoint_default = "http://test-install.blindsidenetworks.com/bigbluebutton/api/"
    config.bigbluebutton_secret_default = "8cd8ef52e8e101574e400365b55e11a6"

    # Use standalone BigBlueButton server.
    config.bigbluebutton_endpoint = if ENV["BIGBLUEBUTTON_ENDPOINT"].present?
      ENV["BIGBLUEBUTTON_ENDPOINT"]
    else
      config.bigbluebutton_endpoint_default
    end

    config.bigbluebutton_secret = if ENV["BIGBLUEBUTTON_SECRET"].present?
      ENV["BIGBLUEBUTTON_SECRET"]
    else
      config.bigbluebutton_secret_default
    end

    # Tell Action Mailer to use smtp server, if configured
    config.action_mailer.delivery_method = ENV['SMTP_SERVER'].present? ? :smtp : :sendmail

    ActionMailer::Base.smtp_settings =
      if ENV['SMTP_AUTH'].present? && ENV['SMTP_AUTH'] != "none"
        {
          address: ENV['SMTP_SERVER'],
          port: ENV["SMTP_PORT"],
          domain: ENV['SMTP_DOMAIN'],
          user_name: ENV['SMTP_USERNAME'],
          password: ENV['SMTP_PASSWORD'],
          authentication: ENV['SMTP_AUTH'],
          enable_starttls_auto: ENV['SMTP_STARTTLS_AUTO'],
        }
      else
        {
          address: ENV['SMTP_SERVER'],
          port: ENV["SMTP_PORT"],
          domain: ENV['SMTP_DOMAIN'],
          enable_starttls_auto: ENV['SMTP_STARTTLS_AUTO'],
        }
      end

    config.admin_name = ENV["INGANG_ADMIN_NAME"] || 'admin'
    config.admin_password = ENV["INGANG_ADMIN_PASSWORD"] || ''

    config.hosts << "vergadering.bij1.org"
  end
end
