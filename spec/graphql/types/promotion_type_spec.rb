require 'rails_helper'

describe Types::PromotionType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'nome' do
    subject { described_class.fields['nome'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'prizes' do
    subject { described_class.fields['prizes'].to_graphql }
    it { is_expected.to be_of_type '[Prize!]' }
  end
end
