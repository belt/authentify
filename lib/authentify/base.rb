require 'savon'
require 'yaml'

module Authentify
  # authentify.net SOAP-XML API... as a PORO
  class Base
    extend Savon::Model
    attr_reader :client

    # TODO: refactor
    APIExampleConfig = 'config/authentify_api_config.example.yml'.freeze
    APIConfigFile = 'config/authentify_api_config.yml'.freeze
    APIConfig = if File.exist? APIConfigFile
                  YAML.load_file APIConfigFile
                else
                  YAML.load_file APIExampleConfig
                end
    LOG_SOAP = ENV.key?('DEBUG_SOAP') && !%w(false 0).include?(ENV['DEBUG_SOAP'])

    def initialize(opts = {})
      @endpoint = opts[:endpoint]

      opts = {wsdl: 'http://xml.authentify.net/AuthentifyService',
              pretty_print_xml: true, log: LOG_SOAP,
              open_timeout: 10, read_timeout: 10}
      opts[:endpoint] = @endpoint if @endpoint

      @client = Savon.client opts
      self
    end

    def api_config
      APIConfig
    end

    def rack_env
      ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end

    def application
      raise 'no application specified'
    end

    def tsoid
      api_config['authentify_tsoid']
    end

    def account
      api_config['authentify_account'][rack_env]
    end

    def session_uri
      api_config['authentify_session_uri'][rack_env]
    end

    def environment
      api_config['authentify_environment'][rack_env]
    end

    def site_license
      api_config['authentify_site_license'][rack_env]
    end
  end
end
