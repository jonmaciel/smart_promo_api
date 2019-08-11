# frozen_string_literal: true

module Mutations
  module Advertisements
    class DeleteAdvertisement < Mutations::BaseMutation
      argument :id, Int, required: true

      field :success, Boolean, null: true

      def resolve(id:)
        @id = id
        @partner = context[:current_user]

        validate!

        advertisement.destroy!

        { success: true }
      rescue GraphQL::ExecutionError, ActiveRecord::RecordNotFound => e
        context.add_error(GraphQL::ExecutionError.new(e.to_s))
      end

      private

      attr_reader :id, :partner

      def advertisement
        @advertisement ||= partner.advertisements.find(id)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless partner.is_a?(Partner)
      end
    end
  end
end
