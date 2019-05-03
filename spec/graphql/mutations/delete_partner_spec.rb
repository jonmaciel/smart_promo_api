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

    context "when the partner has been found" do
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

    context "when the partner has not been found" do
      let(:id) { -1 }

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new partner' do
        expect { result }.to change { Partner.count }.by(0)
      end
    end
  end
end
