require 'rails_helper'

describe Types::PartnerType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'name' do subject { described_class.fields['name'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'adress' do
    subject { described_class.fields['adress'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'cnpj' do
    subject { described_class.fields['cnpj'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'latitude' do
    subject { described_class.fields['latitude'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'longitude' do
    subject { described_class.fields['longitude'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  pending 'Partner profile type'
end
