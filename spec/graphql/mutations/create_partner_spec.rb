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

    before do
    end

    context "when the partner has not been found" do
      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(1)
      end

      it 'creates new partner' do
        expect { result }.to change { Partner.count }.by(1)
      end

      it 'returns the righ partner' do
        partner = result['data']['createPartner']['partner']
        newest_partner = Partner.last
        newest_auth = Auth.last

        expect(partner['id']).to eq newest_partner.id
        expect(partner['name']).to eq name
        expect(partner['adress']).to eq adress
        expect(partner['cnpj']).to eq cnpj
        expect(newest_auth['email']).to eq email
      end
    end
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
    let(:mutation_string) { 
      %| 
        mutation updatePartner($id: Int!, $name: String, $adress: String, $cnpj: String, $email: String, $password: String, $passwordConfirmation: String){
          updatePartner(id: $id, name: $name, adress: $adress, cnpj: $cnpj, email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
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

    it 'creates its auth' do
      expect { result }.to change { Auth.count }.by(0)
    end

    it 'creates new partner' do
      expect { result }.to change { Partner.count }.by(0)
    end

    context "when the partner has not been found" do
      it 'returns the righ partner' do
        result_partner = result['data']['updatePartner']['partner']
        partner.reload
        auth = partner.auth.reload

        expect(result_partner['name']).to eq name
        expect(result_partner['adress']).to eq adress
        expect(result_partner['cnpj']).to eq cnpj
        expect(partner.name).to eq name
        expect(partner.adress).to eq adress
        expect(partner.cnpj).to eq cnpj
        expect(auth.email).to eq email
      end
    end
  end

  describe 'Delete Partner' do
    let!(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: partner) }
    let(:partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let(:id) { partner.id }
    let(:variables) do
      { id: id }
    end
    let(:mutation_string) { 
      %| 
        mutation deletePartner($id: Int!){
          deletePartner(id: $id) {
            success
            errors
          }
        } 
      | 
    }

    context "when the partner has not been found" do
      it 'returns the righ partner' do
        mutation_result = result['data']['deletePartner']['success']

        expect(Partner.find_by(id: id)).to be_nil
        expect(Auth.find_by(id: auth.id)).to be_nil
        expect(mutation_result).to be_truthy
      end

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(-1)
      end

      it 'creates new partner' do
        expect { result }.to change { Partner.count }.by(-1)
      end
    end
  end
end
