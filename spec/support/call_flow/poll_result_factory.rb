require 'authentify/base'

module Authentify
  module CallFlow
    class PollResultFactory < Authentify::Base
      DEFAULT_PARAMS = {
        tsoid: 'AuthentifyGem',
        asid: 'Customer_Identifier',
        sgid: '00000000-0000-0000-0000-000000000000',
        application: 'BioCapture',
        teid: '00000000-0000-0000-0000-000000000000',
        reply_to: 'https://imp1.authentify.com/s2s/default.asp',
        timestamp: Time.now.utc.iso8601,
        status_code: '0'
      }.freeze

      def initialize(opts = {})
        @options = DEFAULT_PARAMS.merge opts
        self
      end

      def to_soap_xml
        Gyoku.xml ({
          AuthentXML: {
            '@xmlns' => 'http://xml.authentify.net/MessageSchema.xml', '@version' => '1.0',
            header:  {tsoid: @options[:tsoid], asid: @options[:asid], sgid: @options[:sgid],
                      teid: @options[:teid], application: @options[:application],
                      replyTo: @options[:reply_to], timestamp: @options[:timestamp]
            },
            body: {result: {
              'action/' => nil,
              status: {statusCode: @options[:status_code]}
            }
            }
          }
        })
      end
    end
  end
end
