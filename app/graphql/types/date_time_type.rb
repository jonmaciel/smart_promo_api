# frozen_string_literal: true

module Types
  class DateTimeType < Types::BaseScalar
    description 'Date Type'

    def self.coerce_input(value, _context)
      Time.zone.parse(value)
    rescue ArgumentError => e
      raise GraphQL::CoercionError, e.to_s
    end

    def self.coerce_result(value, _context)
      value.utc.iso8601
    rescue ArgumentError => e
      raise GraphQL::CoercionError, e.to_s
    end
  end
end
