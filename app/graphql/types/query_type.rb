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

    field :customers, [Types::Customers::CustomerType], null: true

    def partner(args)
      Partner.find_by(id: args[:id])
    end

    def promotion(args)
      Promotion.find_by(id: args[:id], partner_id: args[:partner_id])
    end

    def promotions(args)
      partner = Partner.find_by(id: args[:partner_id])
      partner&.promotions || []
    end

    def customer(args)
      Customer.find_by(id: args[:id])
    end

    def customers
      Customer.all
    end
  end
end
