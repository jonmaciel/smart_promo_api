# frozen_string_literal: true

module Mutations
  module Challenges
    class CreateChallenge < Mutations::BaseMutation
      null true
      description 'Create new challenges'

      argument :name, String, required: false
      argument :goal, Int, required: true
      argument :promotion_type_id, Int, required: true

      field :challenge, Types::Challenges::ChallengeType, null: true

      def resolve(input)
        @name = input[:name]
        @goal = input[:goal]
        @promotion_type_id = input[:promotion_type_id]

        validate!

        challenge.save!

        { challenge: challenge }
      rescue GraphQL::ExecutionError, ActiveRecord::RecordNotFound => e
        add_error(e.to_s)
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end

      private

      attr_accessor :name, :goal, :promotion_type_id

      def challenge
        @challenge ||= Challenge.new(name: name, goal: goal, promotion_type_id: promotion_type_id)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless context[:current_user].adm?
      end
    end
  end
end
