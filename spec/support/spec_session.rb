require 'spec_helper'
require 'webmock/rspec'

RSpec.shared_examples_for 'an authentify session' do
  let(:authentify_session_uri) do
    'https://sandbox.authentify.com/AuthentifyGem_changeth-isto-some-thin-ghexadecimal/'
  end
  let(:authentify_account_name) {'noreply+authentify.gem@authentify.com'}
  let(:authentify_session) do
    session = Authentify::Session.new password: authentify_account_name,
                                      session_uri: authentify_session_uri
    session.login
  end

  let(:post_body) {{'login_box' => ''}}
  let(:authentication_headers) do
    {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate',
     'Content-Type' => 'application/x-www-form-urlencoded', 'User-Agent' => 'Ruby'}
  end
  let(:bio_capture_form) do
    File.read File.expand_path(File.join(File.dirname(__FILE__),
                                         '../authentify/vcr_files/bio_capture_form.html'))
  end

  before :each do
    # NOT DISABLE THIS STUB POST. Doing so will make a live-request to
    # authentify sandbox servers.
    stub_request(:post, authentify_session_uri)
      .with(body: post_body, headers: authentication_headers)
      .to_return(status: 200, body: bio_capture_form, headers: {})
  end
end
