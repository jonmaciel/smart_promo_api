module Types
  module Challenges
    class ChallengeProgressType < Types::BaseObject

      description 'Customer Type'

      field :id, Int, null: true
      field :progress, Int, null: true
      field :chalange, Types::Challenges::ChallengeType, null: true
      field :customer, Types::Customers::CustomerType, null: true
    end
  end
end
