require 'rails_helper'

describe Auth, type: :model do
  describe 'basic validations' do
    xit { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:source) }
  end
end
