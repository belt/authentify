require 'spec_helper'
require 'authentify/session'
require 'authentify/spec'

RSpec.describe Authentify::Session do
  include_examples 'an authentify session'

  subject do
    session = Authentify::Session.new password: authentify_account_name,
                                      session_uri: authentify_session_uri
    session.login
  end

  context 'login' do
    it 'should log in with valid credentials' do
      session = Authentify::Session.new password: authentify_account_name,
                                        session_uri: authentify_session_uri
      session.login
      expect(session.response.code).to be 200
    end

    it 'should capture-and-parse the response body' do
      expect(subject.dom).to_not be_blank
    end

    # TODO: authentify to spec sign out
    xit 'should logout' do
    end
  end
end
