require 'rails_helper'

describe Wallet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:source) }
  end
end
