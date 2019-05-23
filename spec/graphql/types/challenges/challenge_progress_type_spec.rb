# frozen_string_literal: true

require 'rails_helper'

describe Types::Challenges::ChallengeProgressType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'progress' do
    subject { described_class.fields['progress'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'chalange' do
    subject { described_class.fields['chalange'].to_graphql }
    it { is_expected.to be_of_type 'Challenge' }
  end

  describe 'customer' do
    subject { described_class.fields['customer'].to_graphql }
    it { is_expected.to be_of_type 'Customer' }
  end
end
