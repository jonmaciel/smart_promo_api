module Types
  class CustomerType < Types::BaseObject

    description 'Customer Type'

    field :id, Int, null: true
    field :name, String, null: true
    field :cpf, String, null: true
  end
end
