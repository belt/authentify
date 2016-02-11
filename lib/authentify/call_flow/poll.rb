require 'authentify/base'
require 'active_support/inflector'

module Authentify
  module CallFlow
    # makes a polling request, processes the result
    class Poll < Authentify::Base
      attr_reader :teid, :client, :call_status

      def initialize(opts = {})
        @endpoint = opts[:endpoint]
        @teid = opts[:teid]
        @application = opts[:service_type].to_s.camelcase
        @client = super(opts.merge(endpoint: @endpoint)).client
        @call_status = nil
        validate
        self
      end

      def validate
        is_valid = true
        is_valid = false unless @teid
        is_valid = false unless @endpoint
        is_valid = false unless %w(BioCapture BioVerify).include? @application
        raise 'missing :teid or :endpoint or invalid :service_type parameter' unless is_valid
        true
      end

      def submit_request
        @response = @client.call :poll, xml: to_soap_xml
      end

      # TODO: refactor to use DTD to generate?
      def to_soap_xml
        xml = Builder::XmlMarkup.new
        Nokogiri.XML(
          xml.AuthentXML(version: '1.0', xmlns: 'http://xml.authentify.net/MessageSchema.xml') do
            xml_header xml
            xml_body xml
          end
        ).to_xml
      end

      def xml_header(xml)
        xml.header do
          xml.teid @teid
        end
      end

      def xml_body(xml)
        xml.body do
          xml.poll
        end
      end

      def response_header
        @response.hash[:authent_xml][:header]
      end

      def response_body
        @response.hash[:authent_xml][:body]
      end

      def report?
        response_body.key? :report
      end

      def result?
        response_body.key? :result
      end

      def data?
        response_body[:result].key? :data
      end

      def bio_verify?
        @application == 'BioVerify'
      end

      def bio_capture?
        @application == 'BioCapture'
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

      def call_status
        action = response_body[:report][:action]
        if action =~ /confirmationnum/
          @call_status = action.scan(/[[:digit:]]/).join.to_i
        end

        @call_status
      end

      def status_code
        if report?
          response_body[:report][:status][:status_code]
        else
          response_body[:result][:status][:status_code]
        end
      end

      def sgid
        response_header[:sgid] if result?
      end

      def voice_id
        response_body[:result][:data][:vid] if result? && bio_capture?
      end

      def states
        response_body[:result][:data][:states] if result? && bio_verify?
      end

      def status_text
        response_body[:result][:data][:states] if result? && data?
      end
    end
  end
end
