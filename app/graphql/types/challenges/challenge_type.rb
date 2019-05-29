# frozen_string_literal: true

module Types
  module Challenges
    class ChallengeType < Types::BaseObject
      description 'Challenge Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :kind, Int, null: true
      field :goal, Int, null: true
    end
  end
end
