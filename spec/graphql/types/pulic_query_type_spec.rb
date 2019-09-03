# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoPublicApiSchema do
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

  describe 'customer_check' do
    let(:query_string) do
      %|
        query customerCheck($field: PublicCustomerCheckFieldsEnum!, $value: String!) {
          customerCheck(field: $field, value: $value)
        }
      |
    end

    before do
      create(:customer, name: 'Name 1', cpf: '81106348001', auth_attributes: {
               cellphone_number: '41991234577',
               email: 'test1@test1.com',
               password: '123456',
               password_confirmation: '123456'
             })
    end

    context 'check by cpf' do
      let(:variables) { { field: 'CPF', value: '81106348001' } }

      it 'returns true' do
        expect(result['data']['customerCheck']).to be_truthy
      end
    end

    context 'check by cellphone_number' do
      let(:variables) { { field: 'CELLPHONE_NUMBER', value: '41991234577' } }

      it 'returns true' do
        expect(result['data']['customerCheck']).to be_truthy
      end
    end

    context 'check by email' do
      let(:variables) { { field: 'EMAIL', value: 'test1@test1.com' } }

      it 'returns true' do
        expect(result['data']['customerCheck']).to be_truthy
      end
    end

    context 'check by invalid' do
      let(:variables) { { field: 'CELLPHONE_NUMBER', value: '41991234580' } }

      it 'returns false' do
        expect(result['data']['customerCheck']).to be_falsey
      end
    end
  end

  describe 'Tickets' do
    let(:query_string) do
      %(
        query tickets($promotionId: Int!, $cellphoneNumber: String!) {
          tickets(promotionId: $promotionId, cellphoneNumber: $cellphoneNumber) {
            id
            createdAt
          }
        }
      )
    end
    let!(:promotion) { create(:promotion, name: 'Name', description: 'Description', partner: partner, promotion_type: promotion_types(:club)) }
    let(:customer) { create(:customer, name: 'Name', cpf: '07712973946') }
    let(:partner) { create(:partner, name: 'Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:context) { { current_user: auth } }
    let(:wallet) { create(:wallet, source: customer) }
    let!(:ticket1) { create(:ticket, partner: partner, wallet: wallet, contempled_promotion: promotion) }
    let!(:ticket2) { create(:ticket, partner: partner, wallet: wallet) }
    let(:cellphone_number) { auth.cellphone_number }
    let(:variables) do
      {
        promotionId: promotion.id,
        cellphoneNumber: cellphone_number
      }
    end

    context 'where the customer exists' do
      it 'returns all tickets' do
        ticket = result['data']['tickets'][0]

        expect(ticket['id']).to eq ticket1.id
        expect(ticket['createdAt']).to eq ticket1.created_at.utc.iso8601
        expect(result['data']['tickets'].count).to eq 1
      end
    end

    context 'where the customer does not exist' do
      let(:cellphone_number) { '1' }

      it 'returns nothing' do
        expect(result['data']['tickets']).to be_empty
      end
    end
  end

  describe 'promotion_by_partner' do
    let(:partner) { create(:partner, name: 'Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let!(:promotion) { create(:promotion, name: 'Name', description: 'Description', partner: partner, promotion_type: promotion_types(:club)) }
    let(:query_string) do
      %(
        query promotionByPartner ($partnerId: Int!) {
          promotionByPartner(partnerId: $partnerId) {
            id
          }
        }
      )
    end

    context 'where the partner exists' do
      let(:variables) { { partnerId: partner.id } }

      it 'returns the promotion' do
        expect(result['data']['promotionByPartner']['id']).to eq promotion.id
      end
    end

    context 'where the partner does not exist' do
      let(:variables) { { partnerId: -1 } }

      it 'returns nil' do
        expect(result['data']['promotionByPartner']).to be_nil
      end
    end
  end
end
