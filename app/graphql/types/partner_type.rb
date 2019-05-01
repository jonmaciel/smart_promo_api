module Types
  class PartnerType < Types::BaseObject

    description 'Partner Type'

    field :id, Int, null: true
    field :name, String, null: true
    field :adress, String, null: true
    field :cnpj, String, null: true
    field :latitude, String, null: true
    field :longitude, String, null: true
  end
end
