# frozen_string_literal: true

module Types
  module Promotions
    class PromotionType < Types::BaseObject
      description 'Promotion Type'

      field :id, Int, null: true
      field :cost, Int, null: true
      field :goal_quantity, Int, null: true
      field :name, String, null: true
      field :description, String, null: true
      field :start_datetime, Types::DateTimeType, null: true
      field :end_datetime, Types::DateTimeType, null: true
      field :highlighted, Boolean, null: true
      field :index, Float, null: true
      field :active, Boolean, null: true
      field :promotion_type, Types::Promotions::PromotionTypeType, null: true
      field :balance, Int, null: true

      field :partner, Types::Partners::PartnerType, null: true

      def balance
        customer = context[:current_user].source

        return 0 if customer.is_a?(Partner)

        object.tickets.where(wallet: customer.wallet).count
      end
    end
  end
end
