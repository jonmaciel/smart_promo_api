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

  describe 'Create Customer' do
    let(:name) { 'Name' }
    let(:cpf) { '07712973946' }
    let(:cellphone_number) { '41992855073' }
    let(:email) { 'test@mail.com' }
    let(:password) { '123123123' }
    let(:variables) do
      {
        name: name,
        cpf: cpf,
        email: email,
        password: password, 
        passwordConfirmation: password 
      }
    end
    let(:mutation_string) { 
      %| 
        mutation createCostumer($name: String!, $cpf: String!, $email: String!, $password: String!, $passwordConfirmation: String!){
          createCostumer(name: $name,  cpf: $cpf, email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
            customer {
              id
              name
            }
            errors
          }
        } 
      | 
    }

    let(:returned_customer) do
      result['data']['createCostumer']['customer']
    end

    let(:returned_errors) do
      result['data']['createCostumer']['errors']
    end

    let(:newest_customer) do
      Customer.find(returned_customer['id'])
    end

    let(:newest_auth) do
      newest_customer.auth
    end

    let(:newest_wallet) do
      newest_customer.wallet
    end

    context 'when the customer has been found' do
      before do
        date_time = double(DateTime, strftime: 'miliseconds')
        expect(DateTime).to receive(:now).and_return(date_time)
        expect(date_time).to receive(:strftime).with('%Q').and_return('miliseconds')
      end

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(1)
      end

      it 'creates new customer' do
        expect { result }.to change { Customer.count }.by(1)
      end

      it 'creates new wallet' do
        expect { result }.to change { Wallet.count }.by(1)
      end

      it 'returns the righ customer' do
        expect(returned_customer['id']).to eq newest_customer.id
        expect(returned_customer['name']).to eq name
        expect(newest_auth.email).to eq email
        expect(newest_wallet.code).to eq 'miliseconds'
      end
    end

    context 'when the customer has ivalid field value' do
      let(:email) { 'invalid email' }

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new customer' do
        expect { result }.to change { Customer.count }.by(0)
      end

      it 'creates new wallet' do
        expect { result }.to change { Wallet.count }.by(0)
      end
      it 'returns error and not customer' do
        expect(returned_customer).to be_nil
        expect(returned_errors).to eq 'Validation failed: Auth email is invalid'
      end
    end
  end
end
