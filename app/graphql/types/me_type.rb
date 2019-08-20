# frozen_string_literal: true

module Types
  class MeType < Types::BaseObject
    field :partner, Types::Partners::PartnerType, null: true
    field :customer, Types::Customers::CustomerType, null: true

    def partner
      object.source if object.source.is_a?(Partner)
    end

    def customer
      object.source if object.source.is_a?(Customer)
    end
  end
end
