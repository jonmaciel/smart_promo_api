# frozen_string_literal: true

require 'rails_helper'

describe Types::Partners::PartnerProfileType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'name' do
    subject { described_class.fields['name'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'business' do
    subject { described_class.fields['business'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end
end
