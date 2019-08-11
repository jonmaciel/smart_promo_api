# frozen_string_literal: true

require 'rails_helper'

describe Types::Advertisements::AdvertisementType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'title' do
    subject { described_class.fields['title'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'description' do
    subject { described_class.fields['description'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'img_url' do
    subject { described_class.fields['imgUrl'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'start_datetime' do
    subject { described_class.fields['startDatetime'].to_graphql }
    it { is_expected.to be_of_type 'DateTime' }
  end

  describe 'end_datetime' do
    subject { described_class.fields['endDatetime'].to_graphql }
    it { is_expected.to be_of_type 'DateTime' }
  end

  describe 'active' do
    subject { described_class.fields['active'].to_graphql }
    it { is_expected.to be_of_type 'Boolean' }
  end

  describe 'partner' do
    subject { described_class.fields['partner'].to_graphql }
    it { is_expected.to be_of_type 'Partner' }
  end
end
