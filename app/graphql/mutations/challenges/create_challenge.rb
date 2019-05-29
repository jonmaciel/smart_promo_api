# frozen_string_literal: true

module Mutations
  module Challenges
    class CreateChallenge < Mutations::BaseMutation
      null true
      description 'Create new challenges'

      argument :name, String, required: false
      argument :goal, Int, required: true
      argument :kind, Int, required: true

      field :challenge, Types::Challenges::ChallengeType, null: true
      field :errors, String, null: true

      def resolve(input)
        @name = input[:name]
        @goal = input[:goal]
        @kind = input[:kind]

        validate!

        challenge.save!

        { challenge: challenge }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        { challenge: nil, errors: e.to_s }
      end

      private

      attr_accessor :name, :goal, :kind

      def challenge
        @challenge ||= Challenge.new(name: name, goal: goal, kind: kind)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless context[:current_user].adm?
      end
    end
  end
end
