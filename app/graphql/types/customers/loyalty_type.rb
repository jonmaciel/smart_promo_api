# frozen_string_literal: true

module Types
  module Customers
    class LoyaltyType < Types::BaseObject
      description 'Customer Type'

      field :id, Int, null: true
      field :partner, Types::Partners::PartnerType, null: false
      field :balance, Int, null: false
      field :stared, Boolean, null: true
    end
  end
end
