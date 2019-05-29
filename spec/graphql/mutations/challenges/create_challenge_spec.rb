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
    let(:kind) { 1 }
    let(:context_admin) { create(:auth, :adm) }
    let(:context) { { current_user: context_admin } }
    let(:variables) do
      {
        name: name,
        goal: goal,
        kind: kind
      }
    end
    let(:mutation_string) do
      %|
        mutation createChallenge($name: String!, $goal: Int!, $kind: Int!) {
          createChallenge(name: $name, goal: $goal, kind: $kind) {
            challenge {
              id
              name
              goal
              kind
            }
            errors
          }
        }
      |
    end

    let(:returned_challenge) do
      result['data']['createChallenge']['challenge']
    end

    let(:returned_errors) do
      result['data']['createChallenge']['errors']
    end

    let(:newest_challenge) do
      Challenge.find(returned_challenge['id'])
    end

    context 'when the challenge has been found' do
      it 'creates new challenge' do
        expect { result }.to change { Challenge.count }.by(1)
      end

      it 'returns the righ challenge' do
        expect(returned_challenge['id']).to eq newest_challenge.id
        expect(returned_challenge['name']).to eq name
        expect(returned_challenge['goal']).to eq goal
        expect(returned_challenge['kind']).to eq kind
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
