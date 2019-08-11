# frozen_string_literal: true

module Mutations
  module Customers
    class DeleteCustomer < Mutations::BaseMutation
      graphql_name 'DeleteCustomer'
      null true
      description 'Update new customer'

      argument :id, Int, required: true

      field :success, Boolean, null: true

      def resolve(input)
        current_auth = context[:current_user]
        customer = Customer.find(input[:id])
        auth = customer.auth

        return add_error('Invalid user') if current_auth.adm? || auth != current_auth

        customer.destroy!

        { success: true }
      rescue ActiveRecord::RecordNotFound => e
        add_error(e.to_s, extensions: { 'field' => 'root' })
      end
    end
  end
end
