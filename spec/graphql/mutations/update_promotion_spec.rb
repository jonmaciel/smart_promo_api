# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context_partner) { create(:partner, name: 'Name', adress: 'Adress', cnpj: '18210092000108') }
  let(:partner) { context_partner }
  let(:context) { { current_user: partner } }
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
    let(:promotion) { create(:promotion, name: 'Old Name', description: 'Old description', partner: context_partner) }
    let(:name) { 'New Name' }
    let(:description) { 'New Description' }
    let(:id) { promotion.id }
    let(:variables) do
      {
        id: id,
        name: name,
        description: description
      }
    end
    let(:mutation_string) { 
      %| 
        mutation updatePromotion($id: Int!, $name: String, $description: String) {
          updatePromotion(id: $id, name: $name, description: $description) {
            promotion {
              id
              name
              description
            }
            errors
          }
        } 
      | 
    }
    let(:returned_promotion) do
      result['data']['updatePromotion']['promotion']
    end

    let(:returned_errors) do
      result['data']['updatePromotion']['errors']
    end

    let(:newest_promotion) do
      Promotion.find(returned_promotion['id'])
    end

    context 'when the partner has been found' do
      it 'returns the righ promotion' do
        expect(returned_errors).to be_nil
        expect(returned_promotion['id']).to eq newest_promotion.id
        expect(returned_promotion['name']).to eq name
        expect(returned_promotion['description']).to eq description
      end
    end

    context 'when the context partner doews not own the promotion' do
      let(:partner) { create(:partner, name: 'Another partne', adress: 'Adress', cnpj: '18210092000109') }

      it 'returns the righ promotion' do
        expect_any_instance_of(Promotion).to_not receive(:update_attribute)
        expect(returned_promotion).to be_nil
        expect(returned_errors).to eq 'This promotion doews not belongs to context user'
      end
    end

    context 'when the partner has not been found' do
      let(:id) { -1 }

      it 'returns error' do
        expect_any_instance_of(Promotion).to_not receive(:update_attribute)
        expect(returned_promotion).to be_nil
        expect(returned_errors).to eq "Couldn't find Promotion with 'id'=-1"
      end
    end

    context 'when the context user is not a partner' do
      let(:partner) { Customer.create(name: 'test') }

      it 'returns error' do
        expect_any_instance_of(Promotion).to_not receive(:update_attribute)
        expect(returned_promotion).to be_nil
        expect(returned_errors).to eq 'Invalid user'
      end
    end
  end
end
