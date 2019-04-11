module Types
  class PromotionType < Types::BaseObject

    description "Promotion Type" 

    field :id, Int, null: true
    field :name, String, null: true
    field :prizes, [Types::PrizeType], null: true 
  end
end
