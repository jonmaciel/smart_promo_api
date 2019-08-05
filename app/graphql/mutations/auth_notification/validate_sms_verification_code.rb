# frozen_string_literal: true

module Mutations
  module AuthNotification
    class ValidateSmsVerificationCode < Mutations::BaseMutation
      null true

      argument :phone_number, String, required: true
      argument :code, String, required: true

      field :success, Boolean, null: true

      def resolve(input)
        @phone_number = input[:phone_number]
        @code = input[:code]

        validated!

        sms_verification_code.validated = true

        { success: sms_verification_code.save! }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        raise(GraphQL::ExecutionError, e.to_s)
      end

      private

      attr_accessor :phone_number, :code

      def sms_verification_code
        @sms_verification_code ||= SmsVerificationCode.find_by!(phone_number: phone_number)
      end

      def validated!
        raise(GraphQL::ExecutionError, 'Expirated code') if sms_verification_code.after_ten_minutes?
        raise(GraphQL::ExecutionError, 'Invalid code') if sms_verification_code.code != code
      end
    end
  end
end
