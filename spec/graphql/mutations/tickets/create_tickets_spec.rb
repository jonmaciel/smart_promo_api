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
    let!(:auth) { create(:auth, email: 'p@mail.com', cellphone_number: partner_cellphone_number, password: '123456', password_confirmation: '123456', source: partner) }
    let(:customer) { create(:customer, name: 'Name', cpf: '07712973946') }
    let!(:auth_costumer) { create(:auth, email: 'c@mail.com', cellphone_number: customer_cellphone_number, password: '123456', password_confirmation: '123456', source: customer) }
    let(:context) { { current_user: auth } }
    let(:partner_id) { partner.id }
    let(:quantity) { 10 }
    let(:ticket) { create(:ticket, partner: partner, wallet: wallet) }
    let(:ticket_id) { ticket.id }
    let(:cost) { 1 }
    let(:goal_quantity) { 10 }
    let(:customer_cellphone_number) { '41992855077' }
    let(:partner_cellphone_number) { '41992855078' }
    let!(:wallet) { create(:wallet, source: customer) }
    let(:variables) do
      {
        cellphoneNumber: customer_cellphone_number,
        quantity: quantity
      }
    end
    let(:mutation_string) do
      %|
        mutation ($cellphoneNumber: String!, $quantity: Int!, $promotionId: Int) {
          createTickets(cellphoneNumber: $cellphoneNumber, quantity: $quantity, promotionId: $promotionId) {
            success
          }
        }
      |
    end

    let(:returned_success) do
      result['data']['createTickets']['success']
    end

    let(:returned_errors) do
      result['errors']
    end

    describe 'creating tickets' do
      context "creating 10 tickets" do
        it 'just creat the tickets' do
          expect { result }.to change { Ticket.count }.by(quantity)
        end

        it 'moves tickets to wallet' do
          expect { result }.to change { wallet.tickets.count }.by(quantity)
        end
      end

      context 'create and contemplate' do
        let(:promotion_type) { promotion_types(:club) }
        let(:promotion) do
          create(
            :promotion,
            name: 'Old Name',
            description: 'Old description',
            partner: partner,
            promotion_type: promotion_type
          )
        end
        let(:promotion_id) { promotion.id }
        let(:variables) do
          {
            promotionId: promotion_id,
            cellphoneNumber: customer_cellphone_number,
            ticketId: ticket_id,
            quantity: quantity
          }
        end

        context "creating 10 tickets" do
          it 'just creat the tickets' do
            expect { result }.to change { promotion.tickets.count }.by(quantity)
          end
        end
      end
    end

    describe 'erro handling' do
      context 'when the user is not a partner' do
        let(:variables) do
          {
            cellphoneNumber: partner_cellphone_number,
            ticketId: ticket_id,
            quantity: quantity
          }
        end

        it 'just returns error' do
          expect(returned_errors[0]['message']).to eq 'invalid user'
        end
      end

      context 'when custumer has been not found' do
        let(:variables) do
          {
            cellphoneNumber: '41988341100',
            ticketId: ticket_id,
            quantity: quantity
          }
        end

        it 'just returns error' do
          expect(returned_errors[0]['message']).to eq "Couldn't find Auth"
        end
      end

      context 'when the user is not a partner' do
        let(:partner) { create(:customer, name: 'Old Name', cpf: '07712973947') }

        it 'just returns error' do
          expect(returned_errors[0]['message']).to eq 'invalid user'
        end

        it 'creates its auth' do
          expect { result }.to change { Ticket.count }.by(0)
        end
      end

      context 'when quantity is highter than 30' do
        let(:quantity) { 31 }

        it 'returns errors' do
          expect(returned_errors[0]['message']).to eq '30 is the ticket limit'
        end

        it 'creates its auth' do
          expect { result }.to change { Ticket.count }.by(0)
        end
      end
    end
  end
end
