# frozen_string_literal: true

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

  describe 'created_at' do
    subject { described_class.fields['createdAt'].to_graphql }
    it { is_expected.to be_of_type 'DateTime' }
  end
end
