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

  describe 'Create Challenge' do
    let(:name) { 'Name' }
    let(:goal) { 20 }
    let!(:challenge) { create(:challenge, name: 'Name', promotion_type: promotion_types(:club), goal: 3) }
    let(:challenge_id) { challenge.id }
    let(:context_admin) { create(:auth, :adm) }
    let(:context) { { current_user: context_admin } }
    let(:variables) { { challengeId: challenge_id } }
    let(:mutation_string) do
      %|
        mutation deleteChallenge($challengeId: Int!) {
          deleteChallenge(challengeId: $challengeId) {
            success
          }
        }
      |
    end

    let(:returned_success) do
      result['data']['deleteChallenge']['success']
    end

    let(:returned_errors) do
      result['errors'][0]['message']
    end

    let(:newest_challenge) do
      Challenge.find(returned_challenge['id'])
    end

    context 'when the challenge has been found' do

      it 'returns the success' do
        expect(returned_success).to be_truthy
        expect(Challenge.find_by(id: challenge_id)).to be_nil
      end
    end

    context 'when the challenge has ivalid field value' do
      let(:context_admin) { create(:auth) }

      it 'does not creates new challenge' do
        expect { result }.to change { Challenge.count }.by(0)
      end

      it 'returns errors' do
        expect(returned_errors).to eq 'invalid user'
      end
    end
  end
end
