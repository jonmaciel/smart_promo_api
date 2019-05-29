# frozen_string_literal: true

module Types
  module Challenges
    class ChallengeType < Types::BaseObject
      description 'Challenge Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :type, String, null: true, resolve: ->(obj, _, _) { obj.promotion_type.label }
      field :goal, Int, null: true
    end
  end
end
