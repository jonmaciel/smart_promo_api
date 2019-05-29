
# frozen_string_literal: true

module Mutations
  module Challenges
    class DeleteChallenge < Mutations::BaseMutation
      null true
      description 'Create new challenges'

      argument :challenge_id, Int, required: true

      field :success, Boolean, null: true
      field :errors, String, null: true

      def resolve(input)
        @challenge_id = input[:challenge_id]

        validate!

        challenge.destroy!

        { success: true }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        { success: false, errors: e.to_s }
      end

      private

      attr_accessor :challenge_id

      def challenge
        @challenge ||= Challenge.find(challenge_id)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless context[:current_user].adm?
      end
    end
  end
end
