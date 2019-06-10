# frozen_string_literal: true

module Types
  module Challenges
    class ChallengeType < Types::BaseObject
      description 'Challenge Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :type, String, null: true
      field :goal, Int, null: true
      field :progress, Types::Challenges::ChallengeProgressType, null: true

      def type
        object.promotion_type.label
      end

      def progress
        customer = context[:current_user].source

        object.challenge_progress_by_customer(customer)
      end
    end
  end
end
