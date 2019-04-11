module Types
  class PrizeType < Types::BaseObject

    description "Prize Type" 

    field :id, Int, null: true
    field :name, String, null: true
  end
end

