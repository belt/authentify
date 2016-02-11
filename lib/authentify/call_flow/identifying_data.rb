require 'authentify/base'
require 'authentify/session'

module Authentify
  module CallFlow
    # request and process identifying-data form
    class IdentifyingData < Authentify::Base
      attr_reader :application, :digits_in_confirmation_code
      attr_reader :asid, :phone_number, :voice_id, :language, :account
      attr_reader :confirm

      def initialize(opts = {})
        @digits_in_confirmation_code = 10
        @options = opts
        @application = opts[:service_type].to_s.underscore

        # Unique identifier representing the user as assigned by the customer.
        @asid = opts[:account_name]

        @phone_number = opts[:phone_number]
        @voice_id = opts[:voice_id] || ''
        @language = opts[:preferred_language] || 'en-us'
        @account = opts[:account] || ''

        validate
      end

      def validate_with_fail
        phone_number? && service_type? && account_name? && voice_id?
      end
      alias validate validate_with_fail
      alias valid? validate_with_fail

      def phone_number?
        return true if @options.key? :phone_number
        raise 'missing :phone_number parameter'
      end

      def service_type
        return unless @options.key?(:service_type) && (bio_capture? || bio_verify?)
        app = @application.to_s
        %w(bio_capture bio_verify).include?(app) ? app : nil
      end

      def service_type?
        return true unless service_type.blank?
        raise 'missing :service_type parameter'
      end

      def bio_verify?
        @options[:service_type].to_s == 'bio_verify'
      end

      def bio_capture?
        @options[:service_type].to_s == 'bio_capture'
      end

      def account_name?
        return true if @options.key? :account_name
        raise 'missing :account_name parameter'
      end

      def voice_id?
        if bio_verify? && @voice_id.blank?
          raise ':voice_id not specified with {service_type: :bio_verify}'
        end
        true
      end

      def voice_id
        return unless bio_verify?
        @voice_id
      end

      def generate_confirmation_number
        (0..@digits_in_confirmation_code - 1).to_a.map {Random.new.rand(10)}.join('')
      end

      def confirm
        @confirm ||= generate_confirmation_number
      end
    end
  end
end
