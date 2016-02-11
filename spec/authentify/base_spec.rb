require 'spec_helper'
require 'savon/mock/spec_helper'
require 'authentify/base'

RSpec.describe Authentify::Base do
  include Savon::SpecHelper

  before(:all) {savon.mock!}
  after(:all) {savon.unmock!}

  context 'SOAP-XML client' do
    it 'should should not raise instantiation error' do
      expect {Authentify::Base.new}.to_not raise_error
    end
  end

  context 'fixed values' do
    subject {Authentify::Base.new}
    it 'should specify a client' do
      expect(subject.client).to_not be_blank
      expect(subject.client).to be_a(Savon::Client)
    end

    it 'should specify environment' do
      expect(subject.environment).to_not be_blank
      expect(subject.environment).to eq 'imp'
    end

    it 'should not specify application' do
      expect {subject.application}.to raise_error(RuntimeError, 'no application specified')
    end

    it 'should specify tsoid' do
      expect(subject.tsoid).to_not be_blank
      expect(subject.tsoid).to eq 'AuthentifyGem'
    end

    it 'should specify site_license' do
      expect(subject.site_license).to eq 'changeth-isto-some-thin-ghexadecimal'
    end
  end
end
