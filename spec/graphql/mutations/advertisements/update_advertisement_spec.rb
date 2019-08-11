# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context_partner) { create(:partner, name: 'Name', adress: 'Adress', cnpj: '18210092000108') }
  let(:partner) { context_partner }
  let(:context) { { current_user: partner } }
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
    let(:advertisement) { create(:advertisement, title: 'Old Name', description: 'Old description', partner: context_partner) }
    let(:id) { advertisement.id }
    let(:title) { 'New Name' }
    let(:description) { 'New Description' }
    let(:variables) do
      {
        id: id,
        title: title,
        description: description
      }
    end
    let(:mutation_string) do
      %|
        mutation updateAdvertisement($id: Int!, $title: String, $description: String) {
          updateAdvertisement(id: $id, title: $title, description: $description) {
            advertisement {
              id
              title
              description
            }
          }
        }
      |
    end
    let(:returned_advertisement) do
      result['data']['updateAdvertisement']['advertisement']
    end

    let(:returned_errors) { result['errors'][0]['message'] }

    let(:newest_advertisement) do
      Advertisement.find(returned_advertisement['id'])
    end

    context 'when the partner has been found' do
      it 'returns the righ advertisements' do
        expect(returned_advertisement['id']).to eq newest_advertisement.id
        expect(returned_advertisement['title']).to eq title
        expect(returned_advertisement['description']).to eq description
      end
    end

    context 'when the partner has not been found' do
      let(:id) { -1 }

      it 'returns error' do
        expect_any_instance_of(Advertisement).to_not receive(:update_attribute)
        expect(returned_errors).to eq "Couldn't find Advertisement with 'id'=-1"
      end
    end

    context 'when the context user is not a partner' do
      let(:partner) { Customer.create(name: 'test') }

      it 'returns error' do
        expect_any_instance_of(Advertisement).to_not receive(:update_attribute)
        expect(returned_errors).to eq 'invalid user'
      end
    end
  end
end
