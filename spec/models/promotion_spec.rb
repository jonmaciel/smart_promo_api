require 'rails_helper'

describe Promotion, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:partner) }
    it { is_expected.to have_many(:tickets).with_foreign_key(:contempled_promotion_id).inverse_of(:contempled_promotion) }
  end
end
