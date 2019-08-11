# frozen_string_literal: true

module Mutations
  module Promotions
    class DeletePromotion < Mutations::BaseMutation
      graphql_name 'DeletePromotion'
      null true
      description 'Update new partner'

      argument :id, Int, required: true

      field :success, Boolean, null: true

      def resolve(input)
        partner = context[:current_user]

        return add_error('Invalid user') unless partner.is_a?(Partner)

        partner.promotions.find(input[:id]).destroy!

        { success: true }
      rescue ActiveRecord::RecordNotFound => e
        context.add_error(GraphQL::ExecutionError.new(e.to_s, extensions: { 'field' => 'root' }))
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end
    end
  end
end
