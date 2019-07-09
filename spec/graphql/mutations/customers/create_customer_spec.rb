# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoPublicApiSchema do
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
    let(:cellphone_number) { '41992855075' }
    let(:email) { 'test@mail.com' }
    let(:password) { '123123123' }
    let(:variables) do
      {
        name: name,
        cpf: cpf,
        cellphoneNumber: cellphone_number,
        email: email,
        password: password,
        passwordConfirmation: password
      }
    end
    let(:mutation_string) do
      %|
        mutation createCustomer($name: String!, $cpf: String!, $email: String!, $cellphoneNumber: String!, $password: String!, $passwordConfirmation: String!){
          createCustomer(name: $name,  cpf: $cpf, email: $email, password: $password, cellphoneNumber: $cellphoneNumber, passwordConfirmation: $passwordConfirmation) {
            customer {
              id
              name
              email
              cellphoneNumber
            }
            authToken
          }
        }
      |
    end

    let(:returned_customer) do
      result['data']['createCustomer']['customer']
    end

    let(:returned_token) do
      result['data']['createCustomer']['authToken']
    end

    let(:returned_errors) do
      result['errors']
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
        expect(returned_customer['cellphoneNumber']).to eq cellphone_number
        expect(returned_customer['email']).to eq email
        expect(newest_auth.email).to eq email
        expect(newest_wallet.code).to eq 'miliseconds'
      end

      it 'alson creates session' do
        authenticate_user = double(AuthenticateUser, result: { token: 'token' })
        expect(AuthenticateUser).to receive(:call).with(email, password).and_return(authenticate_user)

        expect(returned_token).to eq 'token'
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
        expect(returned_errors.first['message']).to eq 'is invalid'
        expect(returned_errors.first['extensions']['field']).to eq 'auth.email'
      end
    end
  end
end
