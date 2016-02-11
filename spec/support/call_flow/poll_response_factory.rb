require 'authentify/base'

module Authentify
  module CallFlow
    class PollResponseFactory < Authentify::Base
      DEFAULT_PARAMS = {teid: '00000000-0000-0000-0000-000000000000',
                        reply_to: 'https://imp1.authentify.com/s2s/default.asp',
                        timestamp: Time.now.utc.iso8601, status_code: '7000',
                        action: nil}.freeze

      def initialize(opts = {})
        @options = DEFAULT_PARAMS.merge opts
        self
      end

      def to_soap_xml
        Gyoku.xml ({
          AuthentXML: {
            '@xmlns' => 'http://xml.authentify.net/MessageSchema.xml', '@version' => '1.0',
            header:  {teid: @options[:teid],
                      replyTo: @options[:reply_to],
                      timestamp: @options[:timestamp]
            },
            body: {report: {
              action: @options[:action],
              status: {
                statusCode: @options[:status_code]
              }
            }
            }
          }
        })
      end
    end
  end
end
