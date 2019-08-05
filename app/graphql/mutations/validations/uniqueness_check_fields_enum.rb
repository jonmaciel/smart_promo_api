# frozen_string_literal: true

module Mutations
  module Validations
    class UniquenessCheckFieldsEnum < Types::BaseEnum
      value 'CELLPHONE_NUMBER', value: 'cellphone_number'
      value 'EMAIL', value: 'email'
      value 'CPF', value: 'cpf'
    end
  end
end
