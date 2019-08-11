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

  describe 'Update Partner' do
    let!(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: partner) }
    let(:partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let(:id) { partner.id }
    let(:name) { 'New Name' }
    let(:adress) { 'New Adress' }
    let(:email) { 'new@mail.com' }
    let(:cnpj) { '71343766000117' }
    let(:variables) do
      {
        id: id,
        name: name,
        adress: adress,
        cnpj: cnpj,
        email: email
      }
    end
    let(:mutation_string) do
      %|
        mutation updatePartner($id: Int!, $name: String, $adress: String, $cnpj: String, $email: String, $password: String, $passwordConfirmation: String){
          updatePartner(id: $id, name: $name, adress: $adress, cnpj: $cnpj, email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
            partner {
              id
              name
              adress
              cnpj
            }
          }
        }
      |
    end

    let(:returned_partner) do
      result['data']['updatePartner']['partner']
    end

    let(:returned_errors) do
      result['errors'][0]['message']
    end

    let(:reloaded_partner) do
      Partner.find(returned_partner['id'])
    end

    let(:reloaded_auth) do
      reloaded_partner.auth
    end

    context 'when the partner has been found' do
      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new partner' do
        expect { result }.to change { Partner.count }.by(0)
      end

      it 'returns partner and not error' do
        expect(returned_partner['name']).to eq name
        expect(returned_partner['adress']).to eq adress
        expect(returned_partner['cnpj']).to eq cnpj
        expect(reloaded_partner.name).to eq name
        expect(reloaded_partner.adress).to eq adress
        expect(reloaded_partner.cnpj).to eq cnpj
        expect(reloaded_auth.email).to eq email
      end
    end

    context 'when the partner has ivalid field value' do
      let(:email) { 'invalid email' }

      it 'returns error and not partner' do
        expect(returned_errors).to eq 'is invalid'
        expect(result['errors'][0]['extensions']['field']).to eq 'auth.email'
      end
    end

    context 'when the partner has not been found' do
      let(:id) { -1 }

      it 'returns error and not partner' do
        expect(returned_errors).to eq "Couldn't find Partner with 'id'=-1"
      end
    end
  end
end
