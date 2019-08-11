# frozen_string_literal: true

module Mutations
  module Promotions
    class UpdatePromotion < Mutations::BaseMutation
      graphql_name 'UpdatePromotion'
      null true
      description 'Update promotion'

      argument :id, Int, required: true
      argument :name, String, required: false
      argument :description, String, required: false
      argument :kind, Int, required: false
      argument :start_datetime, String, required: false
      argument :end_datetime, String, required: false
      argument :highlighted, Boolean, required: false
      argument :index, Float, required: false
      argument :active, Boolean, required: false

      field :promotion, Types::Promotions::PromotionType, null: true

      def resolve(input)
        @input = input
        @partner = context[:current_user]

        validate!

        promotion.update_attributes!(input)

        { promotion: promotion }
      rescue GraphQL::ExecutionError, ActiveRecord::RecordNotFound => e
        add_error(e.to_s)
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end

      private

      attr_reader :partner, :input

      def promotion
        @promotion ||= Promotion.find(input[:id])
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless partner.is_a?(Partner)
        raise(GraphQL::ExecutionError, 'This promotion doews not belongs to context user') unless promotion.partner == partner
      end
    end
  end
end
