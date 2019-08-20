# frozen_string_literal: true

module Types
  module Customers
    class CustomerType < Types::BaseObject
      description 'Customer Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :cpf, String, null: true
      field :cellphone_number, String, null: true
      field :email, String, null: true

      def cellphone_number
        object.auth.cellphone_number
      end

      def email
        object.auth.email
      end
    end
  end
end
