# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) do
    res = described_class.execute(
      query_string,
      context: context,
      variables: variables
    )

    pp res if res['errors']
    res
  end

  describe 'Partner' do
    let(:partner) { create(:partner, name: 'Abc', cnpj: '71343766000117', adress: 'test') }
    let(:query_string) { %| query partner($id: Int!) { partner(id: $id) { name } } | }
    let(:variables) { { id: id } }
    let(:id) { partner.id }

    before { expect(Partner).to receive(:find_by).with(id: id).once.and_call_original }

    context 'when the partner has not been found' do
      let(:id) { -1 }

      it 'is nil' do
        expect(result['data']['partner']).to be_nil
      end
    end

    context 'when the partner has not been found' do
      it 'returns the righ partner' do
        user_name = result['data']['partner']['name']
        expect(user_name).to eq 'Abc'
      end
    end
  end

  describe 'Promotion' do
    let(:partner) { create(:partner, name: 'Abc', cnpj: '71343766000117', adress: 'test') }
    let!(:promotion) { create(:promotion, name: 'Name', description: 'Description', partner: partner, promotion_type: promotion_types(:club)) }
    let(:query_string) {
      %|
        query promotion($id: Int!, $partnerId: Int!) { promotion(id: $id, partnerId: $partnerId) { name } }
      |
    }
    let(:variables) {
      {
        id: id,
        partnerId: partner_id
      }
    }
    let(:id) { promotion.id }
    let(:partner_id) { partner.id }

    context 'when the partner has not been found' do
      let(:other_partner) { create(:partner, name: 'Abc', cnpj: '71343766000118', adress: 'test') }
      let(:id) { create(:promotion, name: 'Name', description: 'Description', partner: other_partner, promotion_type: promotion_types(:club)).id }

      it 'is nil' do
        expect(result['data']['promotion']).to be_nil
      end
    end

    context 'when the promotion has not been found' do
      it 'returns the righ promotion' do
        user_name = result['data']['promotion']['name']
        expect(user_name).to eq 'Name'
      end
    end
  end

  describe 'Promotions' do
    let(:partner) { create(:partner, name: 'Abc', cnpj: '71343766000117', adress: 'test') }
    let(:variables) { { partnerId: partner_id } }
    let(:partner_id) { partner.id }
    let(:query_string) { %| query promotions($partnerId: Int!) { promotions(partnerId: $partnerId) { name } } | }

    before do
      create(:promotion, name: 'Name', description: 'Description', partner: partner, promotion_type: promotion_types(:fidelidade))
      create(:promotion, name: 'Name 2', description: 'Description 2', partner: partner, promotion_type: promotion_types(:club))
    end

    context 'when the promotion has not been found' do
      it 'returns the righ promotion' do
        first_user_name = result['data']['promotions'][0]['name']
        second_user_name = result['data']['promotions'][1]['name']
        expect(first_user_name).to eq 'Name'
        expect(second_user_name).to eq 'Name 2'
      end
    end

    context 'when the partner has not any promotion'do
      let(:partner_id) { create(:partner, name: 'Abc', cnpj: '71343766000118', adress: 'test').id }

      it 'is nil' do
        expect(result['data']['promotions']).to be_empty
      end
    end
  end

  describe 'Customer' do
    let(:query_string) { %| query customer($id: Int!) { customer(id: $id) { name } } | }
    let(:customer) { create(:customer, name: 'Name 1', cpf: '07712973946') }
    let(:variables) { { id: customer.id } }

    context 'when the customer has been found' do
      it 'returns the righ customer' do
        costumer_name = result['data']['customer']['name']
        expect(costumer_name).to eq 'Name 1'
      end
    end

    context 'when the customer has not been found' do
      let(:variables) { { id: -1 } }

      it 'returns the righ customer' do
        expect(result['data']['customer']).to be_nil
      end
    end
  end

  describe 'Customers' do
    let(:query_string) { %| query customers { customers { name } } | }

    before do
      create(:customer, name: 'Name 1', cpf: '07712973946')
      create(:customer, name: 'Name 2', cpf: '07712973947')
    end

    context 'when the customers have been found' do
      it 'returns all customers ' do
        first_user_name = result['data']['customers'][0]['name']
        second_user_name = result['data']['customers'][1]['name']
        expect(first_user_name).to eq 'Name 1'
        expect(second_user_name).to eq 'Name 2'
      end
    end
  end
end
