# frozen_string_literal: true

module Types
  module Customers
    class CustomerType < Types::BaseObject
      description 'Customer Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :cpf, String, null: true
      field :cellphone_number, String, null: true, resolve: ->(obj, _, _) { obj.auth.cellphone_number }
      field :email, String, null: true, resolve: ->(obj, _, _) { obj.auth.email }
    end
  end
end
