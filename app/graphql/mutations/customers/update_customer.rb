# frozen_string_literal: true

module Mutations
  module Customers
    class UpdateCustomer < Mutations::BaseMutation
      graphql_name 'UpdateCustomer'
      null true
      description 'Update new customer'

      argument :id, Int, required: true
      argument :email, String, required: false
      argument :cellphone_number, String, required: false
      argument :password, String, required: false
      argument :password_confirmation, String, required: false
      argument :name, String, required: false
      argument :cpf, String, required: false

      field :customer, Types::Customers::CustomerType, null: true
      field :errors, String, null: true

      def resolve(input)
        customer = Customer.find(input[:id])
        auth = customer.auth

        if input[:email] || input[:password]
          input[:auth_attributes] = { id: auth.id }
          input[:auth_attributes][:email] = input.delete(:email) if input[:email]
          input[:auth_attributes][:cellphone_number] = input.delete(:cellphone_number) if input[:cellphone_number]
          input[:auth_attributes][:password] = input.delete(:password) if input[:password]
          input[:auth_attributes][:password_confirmation] = input.delete(:password_confirmation) if input[:email]
        end

        input.except!(:id, :email, :password, :password_confirmation)
        customer.update_attributes!(input)

        { customer: customer }
      rescue ActiveRecord::RecordNotFound => e
        { customer: nil, errors: e.to_s }
      rescue ActiveRecord::ActiveRecordError => e
        { customer: nil, errors: e.to_s }
      end
    end
  end
end
