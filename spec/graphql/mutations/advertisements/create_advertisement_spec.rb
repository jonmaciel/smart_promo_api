# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:partner) { create(:partner, name: 'Old Name', adress: 'Old Adress', cnpj: '18210092000108') }
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

  describe 'Create Partner' do
    let(:title) { 'Title' }
    let(:description) { 'Description' }
    let(:img_url) { 'url' }
    let(:start_datetime) { '2017-01-01' }
    let(:end_datetime) { '2017-01-02' }
    let(:variables) do
      {
        title: title,
        description: description,
        imgUrl: img_url,
        startDatetime: start_datetime,
        endDatetime: end_datetime
      }
    end
    let(:mutation_string) do
      %|
        mutation createAdvertisement($title: String!, $description: String!, $imgUrl: String, $startDatetime: DateTime, $endDatetime: DateTime) {
          createAdvertisement(title: $title, description: $description, imgUrl: $imgUrl, startDatetime: $startDatetime, endDatetime: $endDatetime) {
            advertisement {
              id
              title
              description
              imgUrl
              startDatetime
              endDatetime
            }
          }
        }
      |
    end
    let(:returned_advertisement) do
      result['data']['createAdvertisement']['advertisement']
    end

    let(:returned_errors) do
      result['errors'][0]['message']
    end

    let(:newest_advertisement) do
      Advertisement.find(returned_advertisement['id'])
    end

    context 'when the partner has been found' do
      it 'creates new advertisement' do
        expect { result }.to change { Advertisement.count }.by(1)
      end

      it 'returns the righ advertisement' do
        expect(returned_advertisement['id']).to eq newest_advertisement.id
        expect(returned_advertisement['title']).to eq title
        expect(returned_advertisement['imgUrl']).to eq img_url
        expect(returned_advertisement['description']).to eq description
        expect(returned_advertisement['startDatetime']).to eq '2017-01-01T00:00:00Z'
        expect(returned_advertisement['endDatetime']).to eq '2017-01-02T00:00:00Z'
      end
    end

    context 'when the context user is not a partner' do
      let(:partner) { Customer.create(name: 'test') }

      it 'creates new advertisement' do
        expect { result }.to change { Advertisement.count }.by(0)
      end

      it 'returns error and not advertisement' do
        expect(returned_errors).to eq 'Invalid user'
      end
    end
  end
end
