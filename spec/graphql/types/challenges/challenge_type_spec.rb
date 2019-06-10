# frozen_string_literal: true

require 'rails_helper'

describe Types::Challenges::ChallengeType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'name' do
    subject { described_class.fields['name'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'type' do
    subject { described_class.fields['type'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'goal' do
    subject { described_class.fields['goal'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'progress' do
    subject { described_class.fields['progress'].to_graphql }
    it { is_expected.to be_of_type 'ChallengeProgress' }
  end
end
