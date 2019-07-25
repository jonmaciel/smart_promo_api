# frozen_string_literal: true

module Mutations
  module Customers
    class CreateCustomer < Mutations::BaseMutation
      null true
      description 'Create new customer'

      argument :email, String, required: false
      argument :cellphone_number, String, required: true
      argument :name, String, required: true
      argument :cpf, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :customer, Types::Customers::CustomerType, null: true
      field :auth_token, String, null: true

      def resolve(input)
        @customer_attrs = input

        customer.save!

        { customer: customer, auth_token: auth_token }
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          context.add_error(GraphQL::ExecutionError.new(error, extensions: { 'field' => field.to_s }))
        end

        context.add_error(GraphQL::ExecutionError.new('Validation Error', extensions: { 'field' => 'root' }))
      end

      private

      attr_reader :customer_attrs

      def customer
        @customer ||= Customer.new(
          name: customer_attrs[:name],
          cpf: customer_attrs[:cpf],
          auth_attributes: {
            cellphone_number: customer_attrs[:cellphone_number],
            email: customer_attrs[:email],
            password: customer_attrs[:password],
            password_confirmation: customer_attrs[:password_confirmation]
          },
          wallet_attributes: {
            code: DateTime.now.strftime('%Q')
          }
        )
      end

      def auth_token
        AuthenticateUser.call(customer_attrs[:email], customer_attrs[:password]).result[:token]
      end
    end
  end
end
