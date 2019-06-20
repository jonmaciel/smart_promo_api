

# frozen_string_literal: true

require 'rails_helper'

describe Types::Promotions::PromotionTypeType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'label' do
    subject { described_class.fields['label'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'slug' do
    subject { described_class.fields['slug'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end
end
