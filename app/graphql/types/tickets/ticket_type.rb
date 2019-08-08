# frozen_string_literal: true

module Types
  module Tickets
    class TicketType < Types::BaseObject
      description 'Promotion Type'

      field :id, Int, null: true
      field :value, Int, null: true
      field :promotion_contempled, Types::Promotions::PromotionType, null: true
      field :created_at, Types::DateTimeType, null: true
    end
  end
end
