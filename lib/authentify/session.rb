require 'rest-client'
require 'authentify/base'

module Authentify
  # establishes a session to authentify.com and captures a
  # request_verification_token (and response)
  class Session
    attr_reader :password, :authentify_environment, :dom
    attr_reader :raw_response
    alias response raw_response

    # TODO: refactor
    APIExampleConfig = 'config/authentify_api_config.example.yml'.freeze
    APIConfigFile = 'config/authentify_api_config.yml'.freeze
    APIConfig = if File.exist? APIConfigFile
                  YAML.load_file APIConfigFile
                else
                  YAML.load_file APIExampleConfig
                end

    # used by authentify.com to whitelabel
    # if authentify is whitelable and this is anything but blank then status_code == 2160
    def account
      ''
    end

    def rack_env
      ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end

    def initialize(_opts = {})
      @password = account
      @authentify_environment ||= APIConfig['authentify_environment'][rack_env]
      self
    end

    def session_uri
      APIConfig['authentify_session_uri'][rack_env]
    end

    def no_password_error_msg
      "no authentify password given. check #{Authentify::Base::APIConfigFile}"
    end

    def no_session_uri_msg
      "no authentify session_uri given. check #{Authentify::Base::APIConfigFile}"
    end

    def validate
      raise no_password_error_msg unless @password
      raise no_session_uri_msg unless session_uri
    end

    # DRAGONS: This makes an HTTP request to authentify.
    # Developers: make sure this is mock'd
    def login
      validate
      @raw_response = RestClient.post session_uri, login_box: @password
      self
    end

    def dom
      @dom ||= Nokogiri::HTML(response.body)
    end
  end
end
