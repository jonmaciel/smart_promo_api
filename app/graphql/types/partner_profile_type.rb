module Types
  class PartnerProfileType < Types::BaseObject

    description 'Partner Business Type'

    field :id, Int, null: true
    field :name, String, null: true
    field :business, String, null: true
  end
end
