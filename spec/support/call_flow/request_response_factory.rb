require 'authentify/base'
module Authentify
  module CallFlow
    # echos params as a 'response' i.e. in XML format
    class RequestResponseFactory < Authentify::Base
      # TODO: refactor
      APIExampleConfig = 'config/authentify_api_config.example.yml'.freeze
      APIConfigFile = 'config/authentify_api_config.yml'.freeze
      APIConfig = if File.exist? APIConfigFile
                    YAML.load_file APIConfigFile
                  else
                    YAML.load_file APIExampleConfig
                  end

      DEFAULT_PARAMS = {reply_to: 'https://imp1.authentify.com/s2s/default.asp',
                        tsoid: APIConfig['authentify_tsoid'], asid: 'Customer_Identifier',
                        sgid: '00000000-0000-0000-0000-000000000000',
                        teid: '00000000-0000-0000-0000-000000000000',
                        application: 'BioCapture',
                        timestamp: Time.now.utc.iso8601, action: 'ParmsOK', status_code: '7000'
      }.freeze

      def initialize(opts = {})
        @options = DEFAULT_PARAMS.merge opts
        self
      end

      def to_soap_xml
        xml = Builder::XmlMarkup.new
        Gyoku.xml Nori.new.parse(
          xml.AuthentXML(version: '1.0',
                         xmlns: 'http://xml.authentify.net/MessageSchema.xml') do
            xml_header xml
            xml_body xml
          end
        )
      end

      def xml_header(xml)
        xml.header do
          xml.tsoid @options[:tsoid]
          xml.asid @options[:asid]
          xml.sgid @options[:sgid]
          xml.application @options[:application].to_s.camelcase
          xml.teid @options[:teid]
          xml.replyTo @options[:reply_to]
          xml.timestamp @options[:timestamp]
        end
      end

      def xml_body(xml)
        xml.body do
          xml.report do
            xml.action @options[:action]
            xml.status do
              xml.statusCode @options[:status_code]
            end
          end
        end
      end
    end
  end
end
