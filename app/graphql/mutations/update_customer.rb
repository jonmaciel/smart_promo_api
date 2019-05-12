module Mutations
  class UpdateCustomer < Mutations::BaseMutation 
    graphql_name 'UpdateCustomer'
    null true
    description 'Update new customer'

    argument :id, Int, required: true
    argument :email, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false
    argument :name, String, required: false
    argument :cpf, String, required: false 

    field :customer, Types::CustomerType, null: true
    field :errors, String, null: true

    def resolve(input)
      customer = Customer.find(input[:id])
      auth = customer.auth

      if input[:email] || input[:password]
        input[:auth_attributes] = { id: auth.id }
        input[:auth_attributes][:email] = input.delete(:email) if input[:email]
        input[:auth_attributes][:password] = input.delete(:password) if input[:password]
        input[:auth_attributes][:password_confirmation] = input.delete(:password_confirmation) if input[:email]
      end

      input.except!(:id, :email, :password, :password_confirmation)
      customer.update_attributes!(input)
      
      { customer: customer }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, errors: e.to_s }
    rescue ActiveRecord::ActiveRecordError => e
      { success: false, errors: e.to_s }
    end
  end
end
