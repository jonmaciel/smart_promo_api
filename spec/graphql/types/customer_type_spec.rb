require 'rails_helper'

describe Types::CustomerType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'name' do
    subject { described_class.fields['name'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'cpf' do
    subject { described_class.fields['cpf'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end
end

