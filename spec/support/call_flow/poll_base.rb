require 'spec_helper'
require 'authentify'
require 'authentify/spec'

RSpec.shared_examples_for 'an authentify request biometric poll spec' do
  include_examples 'an authentify session'
  include_examples 'the authentify WSDL'
  include_examples 'an authentify biometric capture request'
  include_examples 'an authentify biometric capture poll request'

  context 'bioauthenticate poll' do
    subject do
      Authentify::CallFlow::Poll.new teid: '00000000-0000-0000-0000-000000000000',
                                     endpoint: 'https://imp1.authentify.com/s2s/default.asp',
                                     service_type: 'BioCapture'
    end

    it 'should generate valid xml' do
      fn = File.expand_path File.join(File.dirname(__FILE__),
                                      '../../authentify/dtd/MessageSchema.xml')
      xsd = Nokogiri::XML::Schema File.open(fn)
      xml = Nokogiri.XML subject.to_soap_xml
      xsd.validate xml
    end

    it 'should raise an error when :service_type parameter is not given' do
      expect do
        Authentify::CallFlow::Poll.new teid: '00000000-0000-0000-0000-000000000000'
      end.to raise_error(RuntimeError,
                         'missing :teid or :endpoint or invalid :service_type parameter')
    end

    it 'should raise an error when invalid :service_type parameter is given' do
      expect do
        Authentify::CallFlow::Poll.new teid: '00000000-0000-0000-0000-000000000000',
                                       service_type: 'invalid_service'
      end.to raise_error(RuntimeError,
                         'missing :teid or :endpoint or invalid :service_type parameter')
    end

    it 'should raise an error when :teid parameter is not given' do
      expect do
        Authentify::CallFlow::Poll.new service_type: 'BioVerify'
      end.to raise_error(RuntimeError,
                         'missing :teid or :endpoint or invalid :service_type parameter')
    end

    it 'should raise an error when :endpoint parameter is not given' do
      expect do
        Authentify::CallFlow::Poll.new teid: '00000000-0000-0000-0000-000000000000',
                                       service_type: 'BioVerify'
      end.to raise_error(RuntimeError,
                         'missing :teid or :endpoint or invalid :service_type parameter')
    end

    context 'successfull poll response' do
      before :each do
        stub_poll_response status: 200, headers: {},
                           body: poll_request_biometric_report(status_code: '7000')
        subject.submit_request
      end

      it 'should yield a teid' do
        expect(subject.teid).to eq '00000000-0000-0000-0000-000000000000'
      end

      it 'should yield a reply_to' do
        expect(subject.reply_to).to eq 'https://imp1.authentify.com/s2s/default.asp'
      end

      it 'should yield a timestamp' do
        expect(subject.response_at).to be_a DateTime
      end

      it 'should yield a status code' do
        expect(subject.status_code).to_not be_nil
      end

      it 'should yield a nil call status when the call starts' do
        expect(subject.call_status).to be_nil
      end

      it 'should yield a valid call status when the authentication in the phone call is under progress' do
        stub_poll_response status: 200, headers: {},
                           body: poll_request_biometric_report(action: 'confirmationnum01')
        subject.submit_request

        expect(subject.call_status).to eq 1
      end
    end

    context 'successfull poll result' do
      before :each do
        stub_poll_result status: 200, headers: {},
                         body: poll_request_biometric_result(status_code: '0')
        subject.submit_request
      end

      it 'should yield an sgid' do
        expect(subject.sgid).to eq '00000000-0000-0000-0000-000000000000'
      end
    end
  end
end
