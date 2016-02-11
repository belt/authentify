require 'spec_helper'
require 'authentify'
require 'authentify/spec'

RSpec.describe Authentify::CallFlow::IdentifyingData do
  include_examples 'an authentify session'

  context 'request biocapture' do
    subject do
      opts = {phone_number: '012.345.6789', service_type: :bio_capture,
              account_name: 'noreply+authentify.gem@authentify.com'}
      Authentify::CallFlow::IdentifyingData.new opts
    end

    context 'request verification token' do
      # TODO: confirm authentify-alpha-env does not require this
      xit 'should yield request verification token' do
        expect(subject.request_verification_token).to_not be_nil
      end
    end

    context 'form values' do
      it 'should yield phone number' do
        expect(subject.phone_number).to_not be_blank
        expect(subject.phone_number).to eq '012.345.6789'
      end

      it 'should yield language' do
        expect(subject.language).to_not be_blank
        expect(subject.language).to eq 'en-us'
      end

      it 'should yield asid' do
        expect(subject.asid).to_not be_blank
        expect(subject.asid).to eq 'noreply+authentify.gem@authentify.com'
      end
    end

    context 'named data' do
      it 'should yield confirm' do
        expect(subject.confirm).to_not be_blank
        expect(subject.confirm).to match /(?:\d){10}/
      end
    end

    context 'fixed values' do
      it 'should yield application for authentify' do
        expect(subject.application).to_not be_blank
        expect(subject.application).to eq 'bio_capture'
      end
    end

    context 'parameters' do
      before :each do
        @valid_opts = {service_type: 'bio_verify',
                       voice_id: '00000000-0000-0000-0000-000000000000',
                       phone_number: '123-456-7890',
                       account_name: 'noreply+authentify.gem@authentify.com'}
      end

      context 'requires' do
        it ':phone_number' do
          expect do
            Authentify::CallFlow::IdentifyingData.new @valid_opts.except(:phone_number)
          end.to raise_error(RuntimeError, 'missing :phone_number parameter')
        end

        it ':service_type' do
          expect do
            Authentify::CallFlow::IdentifyingData.new @valid_opts.except(:service_type)
          end.to raise_error(RuntimeError, 'missing :service_type parameter')
        end

        it ':account_name' do
          expect do
            Authentify::CallFlow::IdentifyingData.new @valid_opts.except(:account_name)
          end.to raise_error(RuntimeError, 'missing :account_name parameter')
        end
      end

      context 'optionally accepts' do
        it ':preferred_language' do
          opts = @valid_opts.merge preferred_language: 'en'
          idata = Authentify::CallFlow::IdentifyingData.new opts
          expect(idata.language).to eq 'en'
        end
      end

      context 'invalid' do
        it ':service_type raises error' do
          opts = @valid_opts.merge service_type: 'invalid_service'
          expect do
            Authentify::CallFlow::IdentifyingData.new opts
          end.to raise_error(RuntimeError, 'missing :service_type parameter')
        end
      end
    end
  end
end
