# frozen_string_literal: true

require 'rails_helper'

describe Types::Promotions::PromotionType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'cost' do
    subject { described_class.fields['cost'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'goal_quantity' do
    subject { described_class.fields['goalQuantity'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'name' do
    subject { described_class.fields['name'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'description' do
    subject { described_class.fields['description'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'type' do
    subject { described_class.fields['type'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'highlighted' do
    subject { described_class.fields['highlighted'].to_graphql }
    it { is_expected.to be_of_type 'Boolean' }
  end

  describe 'index' do
    subject { described_class.fields['index'].to_graphql }
    it { is_expected.to be_of_type 'Float' }
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
