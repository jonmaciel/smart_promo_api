# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) do
    res = described_class.execute(
      mutation_string,
      context: context,
      variables: variables
    )

    pp res if res['errors']
    res
  end

  describe 'Update Customer' do
    let!(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:customer) { create(:customer, name: 'Old Name', cpf: '07712973947') }
    let(:id) { customer.id }
    let(:name) { 'New Name' }
    let(:email) { 'new@mail.com' }
    let(:cpf) { '07712973946' }
    let(:variables) do
      {
        id: id,
        name: name,
        cpf: cpf,
        email: email 
      }
    end
    let(:mutation_string) { 
      %| 
        mutation updateCustomer($id: Int!, $name: String, $cpf: String, $email: String, $password: String, $passwordConfirmation: String){
          updateCustomer(id: $id, name: $name, cpf: $cpf, email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
            customer {
              id
              name
              cpf
            }
            errors
          }
        } 
      | 
    }

    let(:returned_customer) do 
      result['data']['updateCustomer']['customer']
    end 

    let(:returned_errors) do 
      result['data']['updateCustomer']['errors']
    end 

    let(:reloaded_customer) do
      Customer.find(returned_customer['id'])
    end

    let(:reloaded_auth) do
      reloaded_customer.auth
    end

    context 'when the customer has been found' do
      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new customer' do
        expect { result }.to change { Customer.count }.by(0)
      end

      it 'returns customer and not error' do
        expect(returned_customer['name']).to eq name
        expect(returned_customer['cpf']).to eq cpf
        expect(reloaded_customer.name).to eq name
        expect(reloaded_customer.cpf).to eq cpf
        expect(reloaded_auth.email).to eq email
        expect(returned_errors).to be_nil
      end
    end

    context 'when the customer has ivalid field value' do
      let(:email) { 'invalid email' }

      it 'returns error and not customer' do
        expect(returned_customer).to be_nil
        expect(returned_errors).to eq 'Validation failed: Auth email is invalid'
      end
    end

    context 'when the customer has not been found' do
      let(:id) { -1 }

      it 'returns error and not customer' do
        expect(returned_customer).to be_nil
        expect(returned_errors).to eq "Couldn't find Customer with 'id'=-1"
      end
    end
  end
end
