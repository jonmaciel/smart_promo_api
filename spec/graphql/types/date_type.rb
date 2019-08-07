# frozen_string_literal: true

require 'rails_helper'

describe Types::DateType do
  describe '#coerce_input' do
    context 'when the date is valid' do
      subject { described_class.coerce_input('2012-01-28', {}) }
      it { is_expected.to eql Date.parse('2012-01-28') }
    end

    context 'when the date is not valid' do
      subject { described_class.coerce_input('2012-31-28', {}) }
      it { expect { subject }.to raise_error(GraphQL::CoercionError, 'invalid date') }
    end
  end

  describe '#coerce_result' do
    let(:date) { Date.parse('2012-01-28') }

    context 'when the date is valid' do
      subject { described_class.coerce_result(date, {}) }
      it { is_expected.to eql date.strftime('%Y-%m-%d') }
    end
  end
end
