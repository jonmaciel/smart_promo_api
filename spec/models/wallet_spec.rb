# frozen_string_literal: true

require 'rails_helper'

describe Wallet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:source) }
    it { is_expected.to have_many(:tickets) }
  end
end
