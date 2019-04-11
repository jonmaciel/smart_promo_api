require 'rails_helper'

RSpec.describe Promotion, type: :model do
  it 'has a valid factory' do
    expect(build(:promotion)).to be_valid
  end

  let(:attributes) do
    { name: 'A test name' }
  end

  let(:promotion) { create(:promotion, **attributes) }

  describe 'model validations' do
    it { expect(promotion).to allow_value(attributes[:name]).for(:name) }
  end

  describe 'model associations' do
    it { expect(promotion).to have_many(:prizes) }
  end
end
