# frozen_string_literal: true

require 'rails_helper'

describe Partner, type: :model do
  describe 'basic validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cnpj) }
    it { is_expected.to validate_presence_of(:adress) }
    it { is_expected.to validate_uniqueness_of(:cnpj) }
    it { is_expected.to validate_length_of(:cnpj).is_equal_to(14) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:auth) }
    it { is_expected.to have_one(:wallet) }
    it { is_expected.to have_many(:promotions) }
  end
end
