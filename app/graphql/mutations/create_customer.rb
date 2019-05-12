module Mutations
  class CreateCustomer < Mutations::BaseMutation 
    graphql_name 'CreateCustomer'
    null true
    description 'Create new customer'

    argument :email, String, required: false
    argument :cellphone_number, String, required: true
    argument :name, String, required: true
    argument :cpf, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :customer, Types::CustomerType, null: true
    field :errors, String, null: true

    def resolve(input)
      customer = Customer.new(
        name: input[:name],
        cpf: input[:cpf],
        auth_attributes: {
          cellphone_number: input[:cellphone_number],
          email: input[:email],
          password: input[:password],
          password_confirmation: input[:password_confirmation],
        },
        wallet_attributes: {
          code: DateTime.now.strftime('%Q')
        }
      )

      customer.save!

      { customer: customer }
    rescue ActiveRecord::ActiveRecordError => e
      { customer: nil, errors: e.to_s }
    end
  end
end
