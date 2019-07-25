# frozen_string_literal: true

require 'rails_helper'

describe Partner, type: :model do
  describe '#methods' do
    let(:sms_verification_code) { SmsVerificationCode.create(phone_number: '1199999999', code: '123456') }

    describe '#after_ten_minutes?' do
      it 'return true if more than 10 minutes' do
        expect(sms_verification_code).to receive(:updated_at).and_return(Time.zone.now - 11.minutes)
        expect(sms_verification_code.after_ten_minutes?).to be_truthy
      end

      it 'return false if less than 10 minutes' do
        expect(sms_verification_code.after_ten_minutes?).to be_falsey
      end
    end
  end
end
