# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :partner, Types::Partners::PartnerType, null: true do
      argument :id, Int, 'Partner ID', required: true
    end

    field :promotion, Types::Promotions::PromotionType, null: true do
      argument :id, Int, 'Promotion ID', required: true
      argument :partner_id, Int, 'Partner ID', required: true
    end

    field :promotions, [Types::Promotions::PromotionType], null: true do
      argument :partner_id, Int, 'Partner ID', required: true
    end

    field :customer, Types::Customers::CustomerType, null: true do
      argument :id, Int, 'Costumer ID', required: true
    end

    field :tickets, [Types::Tickets::TicketType], null: true do
      argument :promotion_id, Int, 'Costumer ID', required: true
    end

    field :me, Types::MeType, null: true
    field :customers, [Types::Customers::CustomerType], null: true
    field :challenges, [Types::Challenges::ChallengeType], null: true
    field :loyalties, [Types::Customers::LoyaltyType], null: true
    field :loyalty, Types::Customers::LoyaltyType, null: true do
      argument :id, Int, 'Loyalty ID', required: true
    end

    def loyalties
      return [] unless context[:current_user].source.is_a?(Customer)

      context[:current_user].source.loyalties
    end

    def loyalty(args)
      return nil unless context[:current_user].source.is_a?(Customer)

      context[:current_user].source.loyalties.find_by(id: args[:id])
    end

    def challenges
      Challenge.all
    end

    def partner(args)
      Partner.find_by(id: args[:id])
    end

    def promotion(args)
      Promotion.find_by(partner_id: args[:partner_id], id: args[:id])
    end

    def promotions(args)
      partner = Partner.find_by(id: args[:partner_id])
      partner&.promotions || []
    end

    def customer(args)
      Customer.find_by(id: args[:id])
    end

    def tickets(promotion_id:)
      return nil unless context[:current_user].source.is_a?(Customer)

      context[:current_user].source.wallet.tickets.where(contempled_promotion_id: promotion_id)
    end

    def customers
      Customer.all
    end

    def me
      context[:current_user]
    end
  end
end
