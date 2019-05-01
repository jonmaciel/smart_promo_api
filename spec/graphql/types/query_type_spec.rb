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

    context "when the partner has not been found" do
      let(:id) { -1 }

      it 'is nil' do
        expect(result['data']['partner']).to be_nil
      end
    end

    context "when the partner has not been found" do
      it 'returns the righ partner' do
        user_name = result['data']['partner']['name']
        expect(user_name).to eq 'Abc'
      end
    end
  end
end
