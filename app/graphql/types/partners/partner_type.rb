# frozen_string_literal: true

module Types
  module Partners
    class PartnerType < Types::BaseObject
      description 'Partner Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :adress, String, null: true
      field :balance, Int, null: true
      field :cnpj, String, null: true
      field :latitude, String, null: true
      field :longitude, String, null: true
      field :promotions, [Types::Promotions::PromotionType], null: true
      field :promotion_count, Int, null: true
      field :cellphone_number, String, null: true
      field :email, String, null: true

      # MVP adaptation
      field :first_promotion, Types::Promotions::PromotionType, null: true

      def cellphone_number
        object.auth.cellphone_number
      end

      def email
        object.auth.email
      end

      def promotion_count
        object.promotions.count
      end

      def balance
        return 0 unless context[:current_user]

        customer = context[:current_user].source

        return 0 if customer.is_a?(Partner)

        customer.wallet.tickets.where(partner: object, contempled_promotion_id: nil).count
      end

      def first_promotion
        return if object.promotions.none?

        object.promotions.first
      end
    end
  end
end
