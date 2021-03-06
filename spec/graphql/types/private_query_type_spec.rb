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
    let(:query_string) do
      %|
        query promotion($id: Int!, $partnerId: Int!) { promotion(id: $id, partnerId: $partnerId) { name } }
      |
    end
    let(:variables) do
      {
        id: id,
        partnerId: partner_id
      }
    end
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

    context 'when the partner has not any promotion' do
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
    let(:query_string) { %( query customers { customers { name } } ) }
    let!(:customer) { create(:customer, name: 'Name 1', cpf: '07712973946') }
    let!(:partner) { create(:partner, name: 'Abc', cnpj: '71343766000117', adress: 'test') }
    let(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: partner) }
    let(:context) { { current_user: auth } }

    before do
      create(:customer, name: 'Name 2', cpf: '07712973947')
      create(:loyalty, customer: customer, partner: partner)
    end

    context 'when the customers have been found' do
      it 'returns all customers ' do
        first_user_name = result['data']['customers'][0]['name']

        expect(first_user_name).to eq 'Name 1'
        expect(result['data']['customers'].size).to eq 1
      end
    end
  end

  describe 'Challenges' do
    let(:query_string) { %( query challenges { challenges { name progress { progress } } } ) }
    let(:customer) { create(:customer, name: 'Name', cpf: '07712973946') }
    let(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:context) { { current_user: auth } }
    let(:promotion_type) { promotion_types(:club) }
    let(:first_challenge) { create(:challenge, name: 'Name 1', promotion_type: promotion_type) }
    let(:second_challenge) { create(:challenge, name: 'Name 2', promotion_type: promotion_type) }

    before do
      ChallengeProgress.create(challenge: first_challenge, customer: customer, progress: 2)
      ChallengeProgress.create(challenge: second_challenge, customer: customer, progress: 1)
    end

    context 'when the challenges have been found' do
      it 'returns all challenges ' do
        first_challenge = result['data']['challenges'][0]
        second_challenge = result['data']['challenges'][1]

        expect(first_challenge['name']).to eq 'Name 1'
        expect(second_challenge['name']).to eq 'Name 2'
        expect(first_challenge['progress']['progress']).to eq 2
        expect(second_challenge['progress']['progress']).to eq 1
      end
    end
  end

  describe 'Challenes' do
    let(:query_string) { %( query challenges { challenges { name progress { progress } } } ) }
    let(:customer) { create(:customer, name: 'Name', cpf: '07712973946') }
    let(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:context) { { current_user: auth } }
    let(:promotion_type) { promotion_types(:club) }
    let(:first_challenge) { create(:challenge, name: 'Name 1', promotion_type: promotion_type) }
    let(:second_challenge) { create(:challenge, name: 'Name 2', promotion_type: promotion_type) }

    before do
      ChallengeProgress.create(challenge: first_challenge, customer: customer, progress: 2)
      ChallengeProgress.create(challenge: second_challenge, customer: customer, progress: 1)
    end

    context 'when the challenges have been found' do
      it 'returns all challenges ' do
        first_challenge = result['data']['challenges'][0]
        second_challenge = result['data']['challenges'][1]

        expect(first_challenge['name']).to eq 'Name 1'
        expect(second_challenge['name']).to eq 'Name 2'
        expect(first_challenge['progress']['progress']).to eq 2
        expect(second_challenge['progress']['progress']).to eq 1
      end
    end
  end

  describe 'Tickets' do
    let(:query_string) do
      %(
        query tickets($promotionId: Int!) {
          tickets(promotionId: $promotionId) {
            id
            createdAt
          }
        }
      )
    end
    let(:variables) { { promotionId: promotion.id } }
    let!(:promotion) { create(:promotion, name: 'Name', description: 'Description', partner: partner, promotion_type: promotion_types(:club)) }
    let(:customer) { create(:customer, name: 'Name', cpf: '07712973946') }
    let(:partner) { create(:partner, name: 'Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:context) { { current_user: auth } }
    let(:wallet) { create(:wallet, source: customer) }
    let!(:ticket1) { create(:ticket, partner: partner, wallet: wallet, contempled_promotion: promotion) }
    let!(:ticket2) { create(:ticket, partner: partner, wallet: wallet) }

    context 'When the user is Customer' do
      it 'returns all tickets' do
        ticket = result['data']['tickets'][0]

        expect(ticket['id']).to eq ticket1.id
        expect(ticket['createdAt']).to eq ticket1.created_at.utc.iso8601
        expect(result['data']['tickets'].count).to eq 1
      end
    end

    context 'When the user is Partner' do
      let(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: partner) }
      let(:context) { { current_user: auth } }

      it 'returns nill' do
        expect(result['data']['tickets']).to be_empty
      end
    end
  end
end
