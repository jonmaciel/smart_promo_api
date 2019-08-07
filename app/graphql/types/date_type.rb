# frozen_string_literal: true

module Types
  class DateType < Types::BaseScalar
    description 'Date Type'

    def self.coerce_input(value, _context)
      Date.parse(value)
    rescue ArgumentError => e
      raise GraphQL::CoercionError, e.to_s
    end

    def self.coerce_result(value, _context)
      value.strftime('%Y-%m-%d')
    rescue ArgumentError => e
      raise GraphQL::CoercionError, e.to_s
    end
  end
end
