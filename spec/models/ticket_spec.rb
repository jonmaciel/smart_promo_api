require 'rails_helper'

describe Ticket, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:promotion_type) }
    it { is_expected.to belong_to(:partner).inverse_of(:wallet) }
    it { is_expected.to belong_to(:wallet).optional }
    it { is_expected.to belong_to(:promotion_contempled).class_name('Promotion').with_foreign_key(:promotion_contempled_id).optional }
  end
end
