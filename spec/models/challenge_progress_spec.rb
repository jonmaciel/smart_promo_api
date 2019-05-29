# frozen_string_literal: true

require 'rails_helper'

describe ChallengeProgress, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:challenge) }
    it { is_expected.to belong_to(:customer) }
  end

  describe 'methods' do
    describe '#increanse_progress' do
      subject { described_class.new }

      it 'increanses quantity' do
        subject.increanse_progress(2)

        expect(subject.progress).to eq 2
      end
    end
  end
end
