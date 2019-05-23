# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '18210092000108') }
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

  describe 'Create Partner' do
    let(:name) { 'Name' }
    let(:description) { 'Description' }
    let(:start_datetime) { '2017-01-01' }
    let(:end_datetime) { '2017-01-02' }
    let(:promotion_type_id) { promotion_types(:club).id }
    let(:highlighted) { false }
    let(:active) { true }
    let(:variables) do
      {
        name: name,
        description: description,
        startDatetime: start_datetime,
        endDatetime: end_datetime,
        promotionTypeId: promotion_type_id,
        active: active,
        highlighted: highlighted
      }
    end
    let(:mutation_string) do
      %|
        mutation createPromotion($name: String!, $promotionTypeId: Int!, $description: String!, $startDatetime: String!, $endDatetime: String!, $highlighted: Boolean, $active: Boolean) {
          createPromotion(name: $name, promotionTypeId: $promotionTypeId, description: $description, startDatetime: $startDatetime, endDatetime: $endDatetime, highlighted: $highlighted, active: $active) {
            promotion {
              id
              name
              description
              startDatetime
              endDatetime
              active
              highlighted
              type
            }
            errors
          }
        }
      |
    end
    let(:returned_promotion) do
      result['data']['createPromotion']['promotion']
    end

    let(:returned_errors) do
      result['data']['createPromotion']['errors']
    end

    let(:newest_promotion) do
      Promotion.find(returned_promotion['id'])
    end

    context 'when the partner has been found' do
      it 'creates new promotion' do
        expect { result }.to change { Promotion.count }.by(1)
      end

      it 'returns the righ promotion' do
        expect(returned_errors).to be_nil
        expect(returned_promotion['id']).to eq newest_promotion.id
        expect(returned_promotion['name']).to eq name
        expect(returned_promotion['description']).to eq description
        expect(returned_promotion['startDatetime']).to eq '2017-01-01 00:00:00 UTC'
        expect(returned_promotion['endDatetime']).to eq '2017-01-02 00:00:00 UTC'
        expect(returned_promotion['active']).to eq active
        expect(returned_promotion['highlighted']).to eq highlighted
        expect(returned_promotion['type']).to eq promotion_types(:club).label
      end
    end

    context 'when the context user is not a partner' do
      let(:partner) { Customer.create(name: 'test') }

      it 'creates new promotion' do
        expect { result }.to change { Promotion.count }.by(0)
      end

      it 'returns error and not promotion' do
        expect(returned_promotion).to be_nil
        expect(returned_errors).to eq 'Invalid user'
      end
    end
  end
end
