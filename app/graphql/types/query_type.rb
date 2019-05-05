module Types
  class QueryType < Types::BaseObject
    field :partner, PartnerType, null: true do
      argument :id, Int, 'Partner ID', required: true
    end

    field :promotion, PromotionType, null: true do
      argument :id, Int, 'Promotion ID', required: true
      argument :partner_id, Int, 'Partner ID', required: true
    end

    field :promotions, [PromotionType], null: true do
      argument :partner_id, Int, 'Partner ID', required: true
    end

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
  end
end
