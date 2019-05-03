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

  describe 'Create Partner' do
    let(:name) { 'Name' }
    let(:adress) { 'Adress' }
    let(:cnpj) { '71343766000117' }
    let(:email) { 'test@mail.com' }
    let(:password) { '123123123' }
    let(:variables) do
      {
        name: name,
        adress: adress,
        cnpj: cnpj,
        email: email,
        password: password, 
        passwordConfirmation: password 
      }
    end
    let(:mutation_string) { 
      %| 
        mutation createPartner($name: String!, $adress: String!, $cnpj: String!, $email: String!, $password: String!, $passwordConfirmation: String!){
          createPartner(name: $name, adress: $adress, cnpj: $cnpj, email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
            partner {
              id
              name
              adress
              cnpj
            }
            errors
          }
        } 
      | 
    }
    let(:returned_partner) do
      result['data']['createPartner']['partner']
    end

    let(:returned_errors) do
      result['data']['createPartner']['errors']
    end

    let(:newest_partner) do
      Partner.find(returned_partner['id'])
    end

    let(:newest_auth) do
      newest_partner.auth
    end

    let(:newest_wallet) do
      newest_partner.wallet
    end

    context 'when the partner has been found' do
      before do
        date_time = double(DateTime, strftime: 'miliseconds')
        expect(DateTime).to receive(:now).and_return(date_time)
        expect(date_time).to receive(:strftime).with('%Q').and_return('miliseconds')
      end

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(1)
      end

      it 'creates new partner' do
        expect { result }.to change { Partner.count }.by(1)
      end

      it 'creates new wallet' do
        expect { result }.to change { Wallet.count }.by(1)
      end

      it 'returns the righ partner' do
        expect(returned_partner['id']).to eq newest_partner.id
        expect(returned_partner['name']).to eq name
        expect(returned_partner['adress']).to eq adress
        expect(returned_partner['cnpj']).to eq cnpj
        expect(newest_auth.email).to eq email
        expect(newest_wallet.code).to eq 'miliseconds'
      end
    end

    context 'when the partner has ivalid field value' do
      let(:email) { 'invalid email' }

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new partner' do
        expect { result }.to change { Partner.count }.by(0)
      end

      it 'creates new wallet' do
        expect { result }.to change { Wallet.count }.by(0)
      end
      it 'returns error and not partner' do
        expect(returned_partner).to be_nil
        expect(returned_errors).to eq 'Validation failed: Auth email is invalid'
      end
    end
  end
end
