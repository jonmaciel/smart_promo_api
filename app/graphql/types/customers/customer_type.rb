# frozen_string_literal: true

module Types
  module Customers
    class CustomerType < Types::BaseObject
      description 'Customer Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :cpf, String, null: true
    end
  end
end
