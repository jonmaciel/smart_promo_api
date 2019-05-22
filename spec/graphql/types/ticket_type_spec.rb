require 'rails_helper'

describe Types::Tickets::TicketType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'value' do
    subject { described_class.fields['value'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'promotion_contempled' do
    subject { described_class.fields['promotionContempled'].to_graphql }
    it { is_expected.to be_of_type 'Promotion' }
  end

  describe 'partner' do
    subject { described_class.fields['partner'].to_graphql }
    it { is_expected.to be_of_type 'Partner' }
  end

  describe 'type' do
    subject { described_class.fields['type'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end
end
