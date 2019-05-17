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
    let(:ticket) { create(:ticket, partner: partner, promotion_type: promotion_types(:club)) }
    let(:customer) { create(:customer, name: 'Customer', cpf: '07712973946') }
    let!(:auth_costumer) { create(:auth, email: 'c@mail.com', cellphone_number: customer_cellphone_number,  password: '123456', password_confirmation: '123456', source: customer) }
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
    let(:mutation_string) { 
      %| 
        mutation ($ticketId: Int!, $cellphoneNumber: String!) {
          giveTicketToUser(ticketId: $ticketId, cellphoneNumber: $cellphoneNumber) {
            success
            errors
          }
        } 
      | 
    }

    let(:returned_success) do 
      result['data']['giveTicketToUser']['success']
    end 

    let(:returned_errors) do 
      result['data']['giveTicketToUser']['errors']
    end 

    before do
      create(:wallet, source: customer)
    end

    context 'moving ticket to wallet' do
      it 'just move the ticket' do
        expect { result }.to change { customer.wallet.tickets.count }.by(1)
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

    context 'when the user is not a partner' do
      let(:variables) do
        {
          cellphoneNumber: partner_cellphone_number,
          ticketId: ticket_id
        }
      end

      it 'just returns error' do
        expect(returned_success).to be_falsey
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
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq "Couldn't find Auth"
      end
    end

    context 'when custumer is not a customer' do
      let(:customer) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '28210092000109') }

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'invalid user'
      end
    end

    context 'when ticket does not belong to customer' do
      let(:second_partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '28210092000108') }
      let(:ticket) { create(:ticket, partner: second_partner, promotion_type: promotion_types(:club)) }

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'invalid user'
      end
    end
  end
end
