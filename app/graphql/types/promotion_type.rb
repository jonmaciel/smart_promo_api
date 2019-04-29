module Types
  class PromotionType < Types::BaseObject

    description 'Promotion Type'

    field :id, Int, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :type, String, null: true
    field :start_datetime, String, null: true
    field :end_datetime, String, null: true
    field :highlighted, Boolean, null: true
    field :index, Float, null: true
    field :active, Boolean, null: true

    field :partner, Types::PartnerType, null: true 
  end
end
