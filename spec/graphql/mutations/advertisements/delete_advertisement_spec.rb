# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context_partner) { create(:partner, name: 'Name', adress: 'Adress', cnpj: '18210092000108') }
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
    let!(:advertisement) { create(:advertisement, title: 'Name', description: 'Description', partner: partner) }
    let(:id) { advertisement.id }
    let(:mutation_result_success) { result['data']['deleteAdvertisement']['success'] }
    let(:mutation_result_errors) { result['errors'][0]['message'] }
    let(:variables) { { id: id } }
    let(:mutation_string) do
      %|
        mutation deleteAdvertisement($id: Int!){
          deleteAdvertisement(id: $id) {
            success
          }
        }
      |
    end

    context "when the partner has been found" do
      it 'returns the righ partner' do
        expect(mutation_result_success).to be_truthy
        expect(Advertisement.find_by(id: id)).to be_nil
      end

      it 'delete its auth' do
        expect { result }.to change { Advertisement.count }.by(-1)
      end
    end

    context "when the promotion does not belongs to partner" do
      let(:partner) { create(:partner, name: 'Other Partner', adress: 'Adress', cnpj: '18210092000109') }

      it 'returns error' do
        expect(mutation_result_errors).to eq "Couldn't find Advertisement with 'id'=#{id} [WHERE \"advertisements\".\"partner_id\" = $1]"
        expect(Advertisement.find_by(id: id)).to be_present
      end

      it 'does not delete promotion' do
        expect { result }.to change { Advertisement.count }.by(0)
      end
    end

    context "when the promotion has not been found" do
      let(:id) { -1 }

      it 'does not delete promotion' do
        expect { result }.to change { Advertisement.count }.by(0)
      end

      it 'returns error' do
        expect(mutation_result_errors).to eq "Couldn't find Advertisement with 'id'=#{id} [WHERE \"advertisements\".\"partner_id\" = $1]"
      end
    end
  end
end
