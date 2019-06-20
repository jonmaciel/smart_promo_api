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
    let(:promotion_type) { promotion_types(:club) }
    let!(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:customer) { create(:customer, name: 'Name', cpf: '07712973946') }
    let!(:wallet) { create(:wallet, source: customer) }
    let(:partner) { create(:partner, name: 'Name', adress: 'Old Adress', cnpj: '18210092000108') }
    let(:ticket) { create(:ticket, partner: partner, wallet: wallet) }
    let(:promotion) { create(:promotion, name: 'Name', description: 'Desc', partner: partner, promotion_type: promotion_type) }
    let(:ticket_id) { ticket.id }
    let(:promotion_id) { promotion.id }
    let(:quantity) { nil }
    let(:context) do
      { current_user: auth }
    end
    let(:variables) do
      {
        ticketId: ticket_id,
        promotionId: promotion_id,
        quantity: quantity
      }
    end
    let(:mutation_string) do
      %|
        mutation ($ticketId: Int, $promotionId: Int!, $quantity: Int) {
          contemplateTicket(ticketId: $ticketId, promotionId: $promotionId, quantity: $quantity) {
            success
            completedChallenges {
              id
            }
            errors
          }
        }
      |
    end

    let(:returned_success) do
      result['data']['contemplateTicket']['success']
    end

    let(:returned_completed_challenges) do
      result['data']['contemplateTicket']['completedChallenges']
    end

    let(:returned_errors) do
      result['data']['contemplateTicket']['errors']
    end

    context 'moving ticket to wallet' do
      it 'just move the ticket' do
        expect { result }.to change { promotion.reload.tickets.count }.by(1)
      end
    end

    describe 'incrense pgrogess' do
      let!(:promotion_1) { create(:challenge, name: 'Promoção semanal', goal: 10, promotion_type: promotion_type) }
      let!(:promotion_2) { create(:challenge, name: 'Promoção mensal', goal: 10, promotion_type: promotion_type) }

      context 'without progress started' do
        it 'create progress if does not exist' do
          expect { result }.to change { ChallengeProgress.count }.by(2)
        end
      end

      context 'with progress started' do
        before do
          ChallengeProgress.create(challenge: promotion_1, customer: customer)
        end

        it 'does not create for exitent progress' do
          expect { result }.to change { ChallengeProgress.count }.by(1)
        end

        it 'does not create for exitent progress' do
          expect(returned_completed_challenges).to be_empty
        end
      end

      context 'riched goal' do
        let!(:promotion_1) { create(:challenge, name: 'Primeiro uso', goal: 1, promotion_type: promotion_type) }

        before do
          ChallengeProgress.create(challenge: promotion_1, customer: customer)
        end

        it 'does not create for exitent progress' do
          expect { result }.to change { ChallengeProgress.count }.by(1)
        end

        it 'does not create for exitent progress' do
          expect(returned_completed_challenges[0]['id']).to eq promotion_1.id
        end
      end

      context 'arleady riched goal' do
        let!(:promotion_1) { create(:challenge, name: 'Primeiro uso', goal: 1, promotion_type: promotion_type) }

        before do
          ChallengeProgress.create(challenge: promotion_1, customer: customer, completed_datetime: Time.now)
        end

        it 'does not create for exitent progress' do
          expect { result }.to change { ChallengeProgress.count }.by(1)
        end

        it 'does not return challenge which was already riched' do
          expect(returned_completed_challenges).to be_empty
        end
      end
    end

    context 'moving ticket to wallet' do
      let(:quantity) { 3 }
      let(:variables) do
        {
          promotionId: promotion_id,
          quantity: quantity
        }
      end

      before do
        create(:ticket, partner: partner, wallet: wallet)
        create(:ticket, partner: partner, wallet: wallet)
        create(:ticket, partner: partner, wallet: wallet)
      end

      it 'just move the ticket' do
        expect { result }.to change { promotion.reload.tickets.count }.by(quantity)
      end
    end

    context 'when the user is not a customer' do
      let(:second_partner) { create(:partner, name: 'Name', adress: 'Old Adress', cnpj: '28210092000109') }
      let!(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: second_partner) }
      let!(:wallet) { create(:wallet, source: second_partner) }

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'invalid user'
      end
    end

    context 'when ticket id and quantity are filled' do
      let(:variables) do
        {
          ticketId: ticket_id,
          promotionId: promotion_id,
          quantity: 2
        }
      end

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'fill just quantity or ticket id'
      end
    end

    context 'when the customer have no tickets enough' do
      let(:variables) do
        {
          promotionId: promotion_id,
          quantity: 2
        }
      end

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'You do\'t have tickets enough'
      end
    end

    context 'when the quantity is greater than 30' do
      let(:variables) do
        {
          promotionId: promotion_id,
          quantity: 31
        }
      end

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq '30 is the ticket limit'
      end
    end

    context 'when ticket does not belong to customer' do
      let(:second_partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '28210092000108') }
      let(:ticket) { create(:ticket, partner: second_partner) }

      it 'just returns error' do
        expect(returned_success).to be_falsey
        expect(returned_errors).to eq 'invalid ticket'
      end
    end
  end
end
