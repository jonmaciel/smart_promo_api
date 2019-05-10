module Types
  class ChallengeProgressType < Types::BaseObject

    description 'Customer Type'

    field :id, Int, null: true
    field :progress, Int, null: true
    field :chalange, Types::ChallengeType, null: true
    field :customer, Types::CustomerType, null: true
  end
end
