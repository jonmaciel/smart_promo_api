require 'rails_helper'

describe Promotion, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:partner) }
  end
end
