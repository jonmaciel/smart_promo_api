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
    let!(:auth) { create(:auth, email: 'p@mail.com', cellphone_number: partner_cellphone_number, password: '123456', password_confirmation: '123456', source: partner) }
    let(:partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let(:promotion_type) { promotion_types(:club) }
    let(:ticket) { create(:ticket, partner: partner) }
    let(:customer) { create(:customer, name: 'Customer', cpf: '07712973946') }
    let!(:auth_costumer) { create(:auth, email: 'c@mail.com', cellphone_number: customer_cellphone_number, password: '123456', password_confirmation: '123456', source: customer) }
    let(:customer_id) { customer.id }
    let(:customer_cellphone_number) { '41992855077' }
    let(:partner_cellphone_number) { '41992855078' }
    let(:ticket_id) { ticket.id }
    let(:context) { { current_user: auth } }
    let(:variables) do
      {
        cellphoneNumber: customer_cellphone_number,
        ticketId: ticket_id
      }
    end
    let(:mutation_string) do
      %|
        mutation ($ticketId: Int!, $cellphoneNumber: String!, $promotionId: Int) {
          giveTicketToUser(ticketId: $ticketId, cellphoneNumber: $cellphoneNumber, promotionId: $promotionId) {
            success
          }
        }
      |
    end

    let(:returned_success) do
      result['data']['giveTicketToUser']['success']
    end

    let(:returned_errors) do
      result['errors'][0]['message']
    end

    before do
      create(:wallet, source: customer)
    end

    describe 'moving ticket to wallet' do
      describe 'it is not a loyalty card' do
        it 'just move the ticket' do
          expect { result }.to change { customer.wallet.tickets.count }.by(1)
        end
      end

      describe 'loyalty card' do
        let(:promotion) { create(:promotion, name: 'Old Name', description: 'Old description', partner: partner, promotion_type: promotion_type) }
        let(:promotion_id) { promotion.id }
        let(:variables) do
          {
            cellphoneNumber: customer_cellphone_number,
            promotionId: promotion_id,
            ticketId: ticket_id
          }
        end

        context 'when promotion exists' do
          it 'crete ticket and move to promotion' do
            expect { result }.to change { promotion.reload.tickets.count }.by(1)
            expect(ticket.reload.contempled_promotion).to eq promotion
          end
        end

        context 'when promotion is sent and does not exist' do
          let(:promotion_id) { -1 }

          it 'crete ticket and move to promotion' do
            expect { result }.to change { promotion.reload.tickets.count }.by(0)
            expect(returned_errors).to eq "Couldn't find Promotion with 'id'=-1"
          end
        end
      end

      describe 'loyalty' do
        context 'when it does not have loyalty' do
          it 'creates loyalty' do
            expect(Loyalty).to receive(:create).with(customer: customer, partner: partner).and_call_original
            expect { result }.to change { Loyalty.count }.by(1)
          end
        end

        context 'when it already has loyalty' do
          before do
            Loyalty.create(customer: customer, partner: partner)
          end

          it 'does not creates loyalty' do
            expect(Loyalty).to_not receive(:create).and_call_original
            expect { result }.to change { Loyalty.count }.by(0)
          end
        end
      end
    end

    describe 'error handling' do
      context 'when the user is not a partner' do
        let(:variables) do
          {
            cellphoneNumber: partner_cellphone_number,
            ticketId: ticket_id
          }
        end

        it 'just returns error' do
          expect(returned_errors).to eq 'invalid user'
        end
      end

      context 'when custumer has been not found' do
        let(:variables) do
          {
            cellphoneNumber: '41988341100',
            ticketId: ticket_id
          }
        end

        it 'just returns error' do
          expect(returned_errors).to eq "Couldn't find Auth"
        end
      end

      context 'when custumer is not a customer' do
        let(:customer) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '28210092000109') }

        it 'just returns error' do
          expect(returned_errors).to eq 'invalid user'
        end
      end

      context 'when ticket does not belong to customer' do
        let(:second_partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '28210092000108') }
        let(:ticket) { create(:ticket, partner: second_partner) }

        it 'just returns error' do
          expect(returned_errors).to eq 'invalid ticket'
        end
      end
    end
  end
end
