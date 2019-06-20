# frozen_string_literal: true

module Types
  module Tickets
    class TicketType < Types::BaseObject
      description 'Promotion Type'

      field :id, Int, null: true
      field :value, Int, null: true
      field :promotion_contempled, Types::Promotions::PromotionType, null: true
      field :partner, Types::Partners::PartnerType, null: true
    end
  end
end
