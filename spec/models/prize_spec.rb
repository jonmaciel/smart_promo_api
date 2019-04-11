require 'rails_helper'

RSpec.describe Prize, type: :model do
  it 'has a valid factory' do
    expect(build(:promotion)).to be_valid
  end

  let(:promotion) { create(:promotion) }
  let(:attributes) do
    {
      name: 'A test prize',
      promotion: promotion
    }
  end

  let(:prize) { create(:prize, **attributes) }

  describe 'model validations' do
    it { expect(prize).to allow_value(attributes[:name]).for(:name) }
    it { expect(prize).to validate_presence_of(:name) }
    it { expect(prize).to validate_uniqueness_of(:name)}
  end

  describe 'model associations' do
    it { expect(prize).to belong_to(:promotion) }
  end
end
