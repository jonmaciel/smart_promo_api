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
    let!(:sms_verification_code) { SmsVerificationCode.create(phone_number: cellphone_number, code: code) }
    let(:name) { 'Name' }
    let(:cpf) { '07712973946' }
    let(:cellphone_number) { '41992855075' }
    let(:code) { '123456' }
    let(:email) { 'test@mail.com' }
    let(:password) { '123123123' }
    let(:variables) do
      {
        code: code,
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
        mutation createCustomer(
          $name: String!, $cpf: String!, $email: String!, $cellphoneNumber: String!, $password: String!, $passwordConfirmation: String!, $code: String!
        ){
          createCustomer(
            name: $name, cpf: $cpf, email: $email, password: $password, cellphoneNumber: $cellphoneNumber, passwordConfirmation: $passwordConfirmation, code: $code
          ) {
            customer {
              id
              name
            }
            authToken
            ticketCount
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

    let(:returned_ticket_count) do
      result['data']['createCustomer']['ticketCount']
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
        expect(newest_auth.email).to eq email
        expect(newest_wallet.code).to eq 'miliseconds'
      end

      it 'creates session' do
        authenticate_user = double(AuthenticateUser, result: { token: 'token' })
        expect(AuthenticateUser).to receive(:call).with(email, password).and_return(authenticate_user)

        expect(returned_token).to eq 'token'
      end

      context 'when the customer already has tickets' do
        let(:partner) { create(:partner) }
        let!(:ticket_1) { create(:ticket, partner: partner, cellphone_number: cellphone_number) }
        let!(:ticket_2) { create(:ticket, partner: partner, cellphone_number: cellphone_number) }

        it 'returns count of ticket that had been created before' do
          expect(returned_ticket_count).to eql 2

          expect(ticket_1.reload.wallet).to eq newest_auth.source.wallet
          expect(ticket_2.reload.wallet).to eq newest_auth.source.wallet
        end
      end
    end

    context 'invalid code' do
      let!(:sms_verification_code) { SmsVerificationCode.create(phone_number: cellphone_number, code: '000000') }

      it 'returns error and not customer' do
        expect(returned_errors.first['message']).to eq 'Invalid Verirification Code'
      end
    end

    context 'when the customer has invalid field value' do
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
