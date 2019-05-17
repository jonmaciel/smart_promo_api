require 'rails_helper'

describe Ticket, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:promotion_type) }
    it { is_expected.to belong_to(:partner).inverse_of(:wallet) }
    it { is_expected.to belong_to(:wallet).optional }
    it { is_expected.to belong_to(:contempled_promotion).class_name('Promotion').with_foreign_key(:contempled_promotion_id).optional }
  end
end
