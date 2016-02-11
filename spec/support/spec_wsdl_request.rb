require 'spec_helper'
require 'webmock/rspec'

RSpec.shared_examples_for 'the authentify WSDL' do
  let(:authentify_wsdl_uri) {'http://xml.authentify.net/AuthentifyService'}
  let(:request_wsdl_headers) do
    {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'User-Agent' => 'Ruby'}
  end

  let(:request_wsdl_xml) do
    File.read File.expand_path(File.join(File.dirname(__FILE__),
                                         '../authentify/dtd/authentify_wsdl.xml'))
  end

  before :each do
    stub_request(:get, authentify_wsdl_uri)
      .with(headers: request_wsdl_headers)
      .to_return(status: 200, body: request_wsdl_xml, headers: {})
  end
end
