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

    # pp res if res['errors']
    res
  end
  let(:variables) do
    {
      phoneNumber: phone_number,
      code: code
    }
  end
  let(:mutation_string) do
    %|
      mutation validateSmsVerificationCode($phoneNumber: String!, $code: String!) {
        validateSmsVerificationCode(phoneNumber: $phoneNumber, code: $code) {
          success
        }
      }
    |
  end

  let!(:sms_verification_code) { SmsVerificationCode.create(phone_number: phone_number, code: code) }
  let(:code) { '123456' }
  let(:phone_number) { '41992855073' }
  let(:error) { result['errors'][0]['message'] }

  before do
    expect(SmsVerificationCode).to receive(:find_by).with(phone_number: phone_number).and_call_original
  end

  describe 'Validate SMS Verification' do
    it 'check validated field' do
      expect { result }.to(change { sms_verification_code.reload.validated? })
    end
  end

  describe 'SMS Verification' do
    context 'wrong phone_number' do
      let!(:sms_verification_code) { SmsVerificationCode.create(phone_number: '41992855075', code: code) }

      it 'check validated field' do
        expect { result }.to_not(change { sms_verification_code.reload.validated? })
        expect(error).to eql "Couldn't find SmsVerificationCode"
      end
    end

    context 'wrong phone_number' do
      let!(:sms_verification_code) { SmsVerificationCode.create(phone_number: phone_number, code: '000000') }

      it 'check validated field' do
        expect { result }.to_not(change { sms_verification_code.reload.validated? })
        expect(error).to eql 'Invalid code'
      end
    end

    context 'wrong code' do
      it 'check validated field' do
        expect_any_instance_of(SmsVerificationCode).to receive(:after_ten_minutes?).and_return(true)
        expect { result }.to_not(change { sms_verification_code.reload.validated? })
        expect(error).to eql 'Expirated code'
      end
    end
  end
end
