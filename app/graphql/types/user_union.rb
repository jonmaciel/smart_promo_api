# frozen_string_literal: true

module Types
  class UserUnion < Types::BaseUnion
    possible_types Types::Customers::CustomerType,
                   Types::Partners::PartnerType

    def self.resolve_type(object, _context)
      if object.is_a?(Customer)
        Types::Partners::PartnerType
      else
        Types::Customers::CustomerType
      end
    end
  end
end
