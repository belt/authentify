require 'spec_helper'
require 'authentify'
require 'authentify/spec'
require File.expand_path(File.join(File.dirname(__FILE__), '../../app/jobs/bio_register_poll_job'))

RSpec.describe BioRegisterPollJob do
  include_examples 'an authentify session'
  include_examples 'the authentify WSDL'
  include_examples 'an authentify biometric capture request'
  include_examples 'an authentify biometric capture poll request'

  context 'valid request' do
    let(:request_biometric) do
      authentify_session = Authentify::Session.new password: 'noreply+authentify.gem@authentify.com'
      options = {dom: authentify_session.dom, phone_number: '012.345.6789', service_type: 'BioCapture'}
      identifying_data = Authentify::CallFlow::IdentifyingData.new options
      Authentify::CallFlow::Request.new identifying_data: identifying_data
    end

    before :each do
      @teid = '00000000-0000-0000-0000-000000000000'
      @endpoint = 'https://imp1.authentify.com/s2s/default.asp'
    end

    subject {BioRegisterPollJob.new(teid: @teid, endpoint: @endpoint, service_type: 'BioCapture')}

    it 'should send a request to Authentify with identifying user information' do
      opts = {status: 200, headers: {},
              body: poll_request_biometric_report(status_code: '0')}
      stub_poll_response(opts)
      subject.perform
      expect(subject.poll.status_code).to eq '0'
    end

    it 'should have status code other than 7000 when the polling gets a result' do
      opts = {status: 200, headers: {},
              body: poll_request_biometric_report(status_code: '0')}
      stub_poll_result(opts)
      subject.perform
      poll = subject.wait_for_result

      expect(poll.status_code).to_not eq '7000'
    end
  end
end
