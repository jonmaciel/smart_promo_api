# frozen_string_literal: true

module Mutations
  module AuthNotification
    class CreateSmsVerificationCode < Mutations::BaseMutation
      null true

      argument :phone_number, String, required: true

      field :success, Boolean, null: true

      def resolve(input)
        @phone_number = input[:phone_number]

        validate!

        sms_verification_code.update_attribute(:code, code) if sms_verification_code.after_ten_minutes?

        Rails.logger.info "### Your code is #{sms_verification_code.code} ###"
        { success: true }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        { success: false, errors: e.to_s }
      end

      private

      attr_accessor :phone_number

      def validate!
        return true if only_number? && phone_number.size == 11

        raise(GraphQL::ExecutionError, 'Inválid Phone Number')
      end

      def sms_verification_code
        @sms_verification_code ||= SmsVerificationCode.find_by(phone_number: phone_number) ||
                                   SmsVerificationCode.create(phone_number: phone_number, code: code)
      end

      def code
        @code ||= 6.times.map { rand(9) }.join
      end

      def only_number?
        phone_number.scan(/\D/).empty?
      end
    end
  end
end
