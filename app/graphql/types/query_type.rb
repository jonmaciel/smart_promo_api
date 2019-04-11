module Types
  class QueryType < Types::BaseObject
    field :promotion, Types::PromotionType, null: true do
      argument :id, ID, 'Promotion ID', required: true
    end

    def promotion(args)
      Promotion.find_by(id: args[:id])
    end
  end
end
