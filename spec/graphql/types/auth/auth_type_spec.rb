# frozen_string_literal: true

require 'rails_helper'

describe Types::Auth::AuthType do
  describe 'id' do
    subject { described_class.fields['id'].to_graphql }
    it { is_expected.to be_of_type 'Int' }
  end

  describe 'email' do
    subject { described_class.fields['email'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end

  describe 'cellphone_number' do
    subject { described_class.fields['cellphoneNumber'].to_graphql }
    it { is_expected.to be_of_type 'String' }
  end
end
