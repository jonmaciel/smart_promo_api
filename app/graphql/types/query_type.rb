module Types
  class QueryType < Types::BaseObject
    field :partner, PartnerType, null: true do
      argument :id, Int, 'Partner ID', required: true
    end

    def partner(args)
      Partner.find_by(id: args[:id])
    end
  end
end
