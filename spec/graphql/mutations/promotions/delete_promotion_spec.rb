# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context_partner) { create(:partner, name: 'Name', adress: 'Adress', cnpj: '18210092000108') }
  let(:promotion_type) { promotion_types(:club) }
  let(:partner) { context_partner }
  let(:context) { { current_user: context_partner } }
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

  describe 'Delete Partner' do
    let!(:promotion) { create(:promotion, name: 'Name', description: 'Description', partner: partner, promotion_type: promotion_type) }
    let(:id) { promotion.id }
    let(:mutation_result_success) { result['data']['deletePromotion']['success'] }
    let(:mutation_result_errors) { result['data']['deletePromotion']['errors'] }
    let(:variables) { { id: id } }
    let(:mutation_string) do
      %|
        mutation deletePromotion($id: Int!){
          deletePromotion(id: $id) {
            success
            errors
          }
        }
      |
    end

    context "when the partner has been found" do
      it 'returns the righ partner' do
        expect(mutation_result_success).to be_truthy
        expect(mutation_result_errors).to be_nil
        expect(Promotion.find_by(id: id)).to be_nil
      end

      it 'delete its auth' do
        expect { result }.to change { Promotion.count }.by(-1)
      end
    end

    context "when the promotion does not belongs to partner" do
      let(:partner) { create(:partner, name: 'Other Partner', adress: 'Adress', cnpj: '18210092000109') }

      it 'returns error' do
        expect(mutation_result_success).to be_falsey
        expect(mutation_result_errors).to eq "Couldn't find Promotion with 'id'=#{id} [WHERE \"promotions\".\"partner_id\" = $1]"
        expect(Promotion.find_by(id: id)).to be_present
      end

      it 'does not delete promotion' do
        expect { result }.to change { Promotion.count }.by(0)
      end
    end

    context "when the promotion has not been found" do
      let(:id) { -1 }

      it 'does not delete promotion' do
        expect { result }.to change { Promotion.count }.by(0)
      end

      it 'returns error' do
        expect(mutation_result_success).to be_falsey
        expect(mutation_result_errors).to eq "Couldn't find Promotion with 'id'=#{id} [WHERE \"promotions\".\"partner_id\" = $1]"
      end
    end
  end
end
