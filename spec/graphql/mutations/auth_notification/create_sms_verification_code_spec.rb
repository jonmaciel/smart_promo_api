# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoPublicApiSchema do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) do
    res = described_class.execute(
      mutation_string,
      context: context,
      variables: variables
    )

    pp res if res['errors']
    res
  end
  let(:variables) do
    {
      phoneNumber: phone_number
    }
  end
  let(:mutation_string) do
    %|
      mutation createSmsVerificationCode($phoneNumber: String!) {
        createSmsVerificationCode(phoneNumber: $phoneNumber) {
          success
        }
      }
    |
  end

  let(:phone_number) { '41992855073' }

  describe 'Create SmsVerificationCode' do
    it 'creates a new SmsVerificationCode' do
      expect { result }.to change { SmsVerificationCode.count }.by(1)
    end

    describe 'when the request had been sent' do
      let!(:sms_verification_code) { SmsVerificationCode.create(phone_number: phone_number, code: '123456') }

      context 'it is being less then 10 minutes' do
        it 'does creates a new SmsVerificationCode' do
          expect { result }.to_not(change { SmsVerificationCode.count })
        end

        it 'updates the code' do
          expect { result }.to_not(change { sms_verification_code.reload.code })
        end
      end

      context 'it is being more then 10 minutes' do
        it 'does creates a new SmsVerificationCode' do
          expect { result }.to_not(change { SmsVerificationCode.count })
        end

        it 'updates the code' do
          expect_any_instance_of(SmsVerificationCode).to receive(:after_ten_minutes?).and_return(true)

          expect { result }.to(change { sms_verification_code.reload.code })
        end
      end
    end
  end

  describe 'Validation' do
    context 'when the phone number has invalid size' do
      let(:phone_number) { '41992853' }

      it 'creates a new SmsVerificationCode' do
        expect { result }.to_not(change { SmsVerificationCode.count })
      end
    end

    context 'when the phone number has invalid caractere' do
      let(:phone_number) { '(41)9928550' }

      it 'creates a new SmsVerificationCode' do
        expect { result }.to_not(change { SmsVerificationCode.count })
      end
    end
  end
end
