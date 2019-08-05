# frozen_string_literal: true

module Mutations
  module Validations
    class UniquenessCheck < Mutations::BaseMutation
      null true

      argument :field, Mutations::Validations::UniquenessCheckFieldsEnum, required: true
      argument :value, String, required: true

      field :valid, Boolean, null: true

      def resolve(field:, value:)
        valid = case field
                when 'cellphone_number'
                  ::Auth.where(cellphone_number: value)
                when 'email'
                  ::Auth.where(email: value)
                when 'cpf'
                  ::Customer.where(cpf: value)
                end.none?

        { valid: valid }
      end
    end
  end
end
