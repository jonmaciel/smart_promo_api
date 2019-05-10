module Types
  class ChallengeType < Types::BaseObject

    description 'Customer Type'

    field :id, Int, null: true
    field :name, String, null: true
    field :type, String, null: true
    field :goal, Int, null: true
  end
end
