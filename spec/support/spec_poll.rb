require 'spec_helper'
require 'webmock/rspec'
require 'authentify'
require 'authentify/spec'

RSpec.shared_examples_for 'an authentify biometric capture poll request' do
  let(:authentify_api_poll_uri) {'https://imp1.authentify.com/s2s/default.asp'}
  let(:poll_request_biometric_headers) do
    {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'Content-Type' => 'text/xml;charset=UTF-8',
     'Soapaction' => '"http://xml.authentify.net/AuthentifyService/Poll"',
     'User-Agent' => 'Ruby'}
  end

  let(:poll_klass) do
    Authentify::CallFlow::Poll
  end

  let(:poll_request) do
    request_biometric_poll = poll_klass.new teid: '00000000-0000-0000-0000-000000000000',
                                            service_type: 'BioCapture',
                                            endpoint: 'https://imp1.authentify.com/s2s/default.asp'
    request_biometric_poll.to_soap_xml
  end

  let(:verify_poll_request) do
    request_biometric_poll = poll_klass.new teid: '00000000-0000-0000-0000-000000000000',
                                            service_type: 'BioVerify',
                                            endpoint: 'https://imp1.authentify.com/s2s/default.asp'
    request_biometric_poll.to_soap_xml
  end

  def stub_poll_response(opts = {})
    stub_request(:post, authentify_api_poll_uri)
      .with(body: poll_request, headers: poll_request_biometric_headers)
      .to_return(opts)
  end

  def stub_poll_result(opts = {})
    stub_request(:post, authentify_api_poll_uri)
      .with(body: poll_request, headers: poll_request_biometric_headers)
      .to_return(opts)
  end

  def stub_verify_poll_response(opts = {})
    stub_request(:post, authentify_api_poll_uri)
      .with(body: verify_poll_request, headers: poll_request_biometric_headers)
      .to_return(opts)
  end

  def stub_verify_poll_result(opts = {})
    stub_request(:post, authentify_api_poll_uri)
      .with(body: verify_poll_request, headers: poll_request_biometric_headers)
      .to_return(opts)
  end

  def poll_request_biometric_report(opts = {})
    Authentify::CallFlow::PollResponseFactory.new(opts).to_soap_xml
  end

  def poll_request_biometric_result(opts = {})
    Authentify::CallFlow::PollResultFactory.new(opts).to_soap_xml
  end
end
