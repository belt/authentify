require 'spec_helper'
require 'authentify'
require 'authentify/spec'

RSpec.shared_examples_for 'an authentify request biometric spec' do
  include_examples 'an authentify session'
  include_examples 'the authentify WSDL'
  include_examples 'an authentify biometric capture request'

  context 'request bioauthenticate' do
    let(:request_biometric_response) do
      response_xml = Authentify::CallFlow::RequestResponseFactory.new.to_soap_xml
      Gyoku.xml Nori.new.parse(response_xml)
    end

    let(:request_biometric) do
      opts = {account_name: 'noreply+authentify.gem@authentify.com',
              phone_number: '012.345.6789', service_type: :bio_capture}
      identifying_data = Authentify::CallFlow::IdentifyingData.new opts
      Authentify::CallFlow::Request.new identifying_data: identifying_data
    end

    subject {request_biometric}

    before :each do
      stub_request(:post, authentify_api_uri)
        .with(body: request_biometric.to_soap_xml, headers: request_biometric_headers)
        .to_return(status: 200, body: request_biometric_response, headers: {})
    end

    context 'bio-register' do
      it 'should generate valid XML' do
        fn = File.expand_path File.join(File.dirname(__FILE__),
                                        '../../authentify/dtd/MessageSchema.xml')
        xsd = Nokogiri::XML::Schema File.open(fn)
        xml = Nokogiri.XML subject.to_soap_xml
        xsd.validate(xml)
      end

      it 'should submit bio-capture/bio-verify request via SOAP-XML' do
        req = subject.submit_request
        expect(req.success?).to be true
      end

      context 'successful bio-capture/bio-verify' do
        before :each do
          subject.submit_request
        end

        it 'should yield a tsoid' do
          expect(subject.tsoid).to eq 'AuthentifyGem'
        end

        it 'should yield an asid' do
          expect(subject.asid).to eq 'Customer_Identifier'
        end

        it 'should yield an sgid' do
          expect(subject.sgid).to eq '00000000-0000-0000-0000-000000000000'
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

        it 'should yield a response status code' do
          expect(subject.response_status_code).to_not be_nil
        end

        it 'should raise an error when identifying data parameter is not given' do
          request = Authentify::CallFlow::Request.new
          expect do
            request.valid?
          end.to raise_error(RuntimeError, 'missing or invalid :identifying_data parameter')
        end

        it 'should raise an error when identifying data parameter is invalid' do
          request = Authentify::CallFlow::Request.new identifying_data: 'invalid_identifying_data'
          expect do
            request.valid?
          end.to raise_error(RuntimeError, 'missing or invalid :identifying_data parameter')
        end
      end
    end
  end
end
