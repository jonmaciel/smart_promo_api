require 'rails_helper'

describe Types::CustomerType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'name' do subject { described_class.fields['name'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'description' do
    subject { described_class.fields['description'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'kind' do
    subject { described_class.fields['kind'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'start_datetime' do
    subject { described_class.fields['startDatetime'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'end_datetime' do
    subject { described_class.fields['endDatetime'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'highlighted' do
    subject { described_class.fields['highlighted'].to_graphql }
    it { is_expected.to be_of_type 'Boolean' }
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

