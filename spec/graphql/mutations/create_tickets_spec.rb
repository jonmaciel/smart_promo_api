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
    let(:context) { { current_user: auth } }
    let(:partner_id) { partner.id }
    let(:promotion_type) { promotion_types(:club) }
    let(:promotion_type_id) { promotion_type.id }
    let(:quantity) { 10 }
    let(:variables) do
      {
        promotionTypeId: promotion_type_id,
        quantity: quantity
      }
    end
    let(:mutation_string) { 
      %| 
        mutation ($promotionTypeId: Int!, $quantity: Int!) {
          createTickets(promotionTypeId: $promotionTypeId, quantity: $quantity) {
            success
            errors
          }
        } 
      | 
    }

    let(:returned_success) do 
      result['data']['createTickets']['success']
    end 

    let(:returned_errors) do 
      result['data']['createTickets']['errors']
    end 

    context "creating 10 tickets" do
      it 'just creat the tickets' do
        expect { result }.to change { Ticket.count }.by(quantity)
      end
    end

    context 'when the user is not a partner' do
      let(:partner) { create(:customer, name: 'Old Name', cpf: '07712973946') }

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'invalid user'
      end

      it 'creates its auth' do
        expect { result }.to change { Ticket.count }.by(0)
      end
    end

    context 'when quantity is highter than 30' do
      let(:quantity) { 31 }

      it 'returns errors' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq '30 is the ticket limit'
      end

      it 'creates its auth' do
        expect { result }.to change { Ticket.count }.by(0)
      end
    end
  end
end
