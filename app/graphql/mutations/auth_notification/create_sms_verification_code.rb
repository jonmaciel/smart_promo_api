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

        if sms_verification_code.validated? || sms_verification_code.after_ten_minutes?
          sms_verification_code.update_attributes(code: code, validated: false)
        end

        Rails.logger.info "###########################"
        Rails.logger.info "### Your code is #{sms_verification_code.code} ###"
        Rails.logger.info "###########################"

        { success: true }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        context.add_error(GraphQL::ExecutionError.new(e.to_s, extensions: { 'field' => 'root' }))
      end

      private

      attr_accessor :phone_number

      def validate!
        unless only_number? && phone_number.size == 11
          raise(GraphQL::ExecutionError, 'Número de celular inválido')
        end

        if ::Auth.where(cellphone_number: phone_number).one?
          raise(GraphQL::ExecutionError, 'Número de celular já cadastrado')
        end

        true
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
