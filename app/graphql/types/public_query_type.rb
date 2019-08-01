# frozen_string_literal: true

module Types
  class PublicQueryType < Types::BaseObject
    field :customer_check, Boolean, null: true do
      argument :field, Types::PublicCustomerCheckFieldsEnum, required: true
      argument :value, String, required: true
    end

    def customer_check(field:, value:)
      case field
      when 'cellphone_number'
        Auth.where(cellphone_number: value)
      when 'email'
        Auth.where(email: value)
      when 'cpf'
        Customer.where(cpf: value)
      end.any?
    end
  end
end
