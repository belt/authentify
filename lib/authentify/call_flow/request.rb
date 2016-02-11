require 'authentify/call_flow/poll'

module Authentify
  module CallFlow
    # generate SOAP-XML request-for-bio_capture, process results
    class Request < Authentify::Base
      attr_reader :identifying_data, :client

      def initialize(opts = {})
        @options = opts
        @endpoint = opts[:endpoint] || APIConfig['authentify_api_request_uri'][rack_env]
        @voice_id = opts[:voice_id]
        @identifying_data = opts[:identifying_data]
        @client = super(opts.merge(endpoint: @endpoint)).client
        self
      end

      def validate
        is_valid = true
        is_valid = false unless @identifying_data
        is_valid = false unless @identifying_data.respond_to?(:valid?) && @identifying_data.valid?
        raise 'missing or invalid :identifying_data parameter' unless is_valid
        true
      end
      alias valid? validate

      # DRAGONS! This makes a SOAP-XML request to authentify.
      # Developers: make sure this is mock'd
      def submit_request
        @response = @client.call :request, xml: to_soap_xml
      end

      # TODO: refactor to use DTD to generate?
      def to_soap_xml
        validate
        Nokogiri::XML::Builder.new do |xml|
          xml.AuthentXML(version: '1.0', xmlns: 'http://xml.authentify.net/MessageSchema.xml') do
            xml_header xml
            xml_body xml
          end
        end.to_xml
      end

      def xml_header(xml)
        xml.header do
          xml.tsoid @identifying_data.tsoid
          xml.asid @identifying_data.asid
          xml.application @identifying_data.application.to_s.camelcase
          xml.account @identifying_data.account
          xml.licenseKey @identifying_data.site_license
        end
      end

      def xml_body(xml)
        xml.body do
          xml.request do
            xml.data(xmlns: 'http://xml.authentify.net/CommonDataSchema.xml') do
              if @identifying_data.application.to_s.underscore == 'bio_verify'
                xml.VID @identifying_data.voice_id
              end
              xml.language @identifying_data.language
              xml.phoneNumber @identifying_data.phone_number
              xml_named_data xml
            end
          end
        end
      end

      def xml_named_data(xml)
        xml.namedData do
          xml.dataItem(name: 'confirmNumberOne') {xml.text @identifying_data.confirm}
          xml.dataItem(name: 'confirmNumberTwo') {xml.text @identifying_data.confirm}
          xml.dataItem(name: 'confirmNumberThree') {xml.text @identifying_data.confirm}
        end
      end

      # authentify does not wrap it's response in an envelope
      def response_header
        @response.hash[:authent_xml][:header]
      end

      # authentify does not wrap it's response in an envelope
      def response_body
        @response.hash[:authent_xml][:body]
      end

      def application
        @identifying_data.application.to_s.camelcase
      end

      def asid
        response_header[:asid]
      end

      def sgid
        response_header[:sgid]
      end

      def teid
        response_header[:teid]
      end

      def reply_to
        response_header[:reply_to]
      end

      def response_at
        response_header[:timestamp]
      end

      def response_status_code
        response_body[:report][:status][:status_code]
      end

      def response_status_text
        response_body[:report][:status][:status_text]
      end
    end
  end
end
