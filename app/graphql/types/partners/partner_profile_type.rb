module Types
  module Partners
    class PartnerProfileType < Types::BaseObject

      description 'Partner Business Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :business, String, null: true
    end
  end
end
