module Types
  class TicketType < Types::BaseObject

    description 'Promotion Type'

    field :id, Int, null: true
    field :value, Int, null: true
    field :promotion_contempled, Types::PromotionType, null: true
    field :partner, Types::PartnerType, null: true
    field :type, String, null: true, resolve: -> (obj, _, _) { obj.promotion_type.label }
  end
end
