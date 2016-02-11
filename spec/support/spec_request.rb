require 'spec_helper'
require 'webmock/rspec'
require 'authentify/spec'

RSpec.shared_examples_for 'an authentify biometric capture request' do
  # DRAGONS! This is authentify's production environment
  let(:authentify_api_uri) {'https://imp.authentify.com/s2s/default.asp'}
  let(:request_biometric_headers) do
    {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'Content-Type' => 'text/xml;charset=UTF-8',
     'Soapaction' => '"http://xml.authentify.net/AuthentifyService/Request"',
     'User-Agent' => 'Ruby'}
  end
  let(:request_biometric_response) do
    response_xml = Authentify::CallFlow::RequestResponseFactory.new.to_soap_xml
    Gyoku.xml Nori.new.parse(response_xml)
  end

  let(:verify_request_biometric_response) do
    response = Authentify::CallFlow::RequestResponseFactory.new application: 'BioVerify'
    response_xml = response.to_soap_xml
    Gyoku.xml Nori.new.parse(response_xml)
  end
end
