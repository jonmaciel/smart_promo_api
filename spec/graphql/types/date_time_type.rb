# frozen_string_literal: true

require 'rails_helper'

describe Types::DateTimeType do
  describe '#coerce_input' do
    context 'when the date is valid' do
      subject { described_class.coerce_input('2012-01-28 10:20', {}) }
      it { is_expected.to eql Time.zone.parse('2012-01-28 10:20') }
    end

    context 'when the date is not valid' do
      subject { described_class.coerce_input('2012-31-28 10:20', {}) }
      it { expect { subject }.to raise_error(GraphQL::CoercionError, 'argument out of range') }
    end
  end

  describe '#coerce_result' do
    let(:date_time) { Time.zone.parse('2012-01-28 10:20') }

    context 'when the date is valid' do
      subject { described_class.coerce_result(date_time, {}) }
      it { is_expected.to eql date_time.utc.iso8601 }
    end
  end
end
