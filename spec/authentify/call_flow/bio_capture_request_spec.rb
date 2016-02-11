require 'spec_helper'
require 'authentify'
require 'authentify/spec'

RSpec.describe Authentify::CallFlow::Request do
  include_examples 'an authentify request biometric spec'

  let(:request_biometric) do
    opts = {account_name: 'noreply+authentify.gem@authentify.com',
            phone_number: '012.345.6789',
            service_type: :bio_capture,
            voice_id: '00000000-0000-0000-0000-000000000000'}
    identifying_data = Authentify::CallFlow::IdentifyingData.new opts
    Authentify::CallFlow::Request.new identifying_data: identifying_data
  end

  let(:request_biometric_response) do
    response_xml = Authentify::CallFlow::RequestResponseFactory.new.to_soap_xml
    Gyoku.xml Nori.new.parse(response_xml)
  end

  context 'bio-register' do
    subject {request_biometric}

    before :each do
      stub_request(:post, authentify_api_uri)
        .with(body: request_biometric.to_soap_xml, headers: request_biometric_headers)
        .to_return(status: 200, body: request_biometric_response, headers: {})
      subject.submit_request
    end

    it 'should yield an application equal to BioCapture' do
      expect(subject.application).to eq 'BioCapture'
    end
  end
end
