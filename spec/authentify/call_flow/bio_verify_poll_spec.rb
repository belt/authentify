require 'spec_helper'
require 'authentify'
require 'authentify/spec'

RSpec.describe Authentify::CallFlow::Poll do
  include_examples 'an authentify request biometric poll spec'

  context 'bioverify poll' do
    before :each do
      stub_verify_poll_response status: 200, headers: {},
                                body: poll_request_biometric_report(status_code: '7000')
    end

    subject do
      Authentify::CallFlow::Poll.new teid: '00000000-0000-0000-0000-000000000000',
                                     endpoint: 'https://imp1.authentify.com/s2s/default.asp',
                                     service_type: 'BioVerify'
    end

    it 'should have status code of 7000 when the out-of-band verification is in progress' do
      subject.submit_request
      expect(subject.status_code).to eq '7000'
    end

    it 'should have status code other than 7000 when the out-of-band registration completes' do
      stub_verify_poll_response status: 200, headers: {},
                                body: poll_request_biometric_report(status_code: '0')
      subject.submit_request
      expect(subject.status_code).to_not eq '7000'
    end

    it 'should have a nil call status before the first utterance' do
      stub_verify_poll_response status: 200, headers: {},
                                body: poll_request_biometric_report(action: nil)
      subject.submit_request

      expect(subject.call_status).to eq nil
    end

    it 'should have a valid call status as soon as the first utterance starts' do
      stub_verify_poll_response status: 200, headers: {},
                                body: poll_request_biometric_report(action: 'confirmationnum01')
      subject.submit_request

      expect(subject.call_status).to eq 1
    end
  end
end
