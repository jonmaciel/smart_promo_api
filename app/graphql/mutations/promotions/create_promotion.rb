# frozen_string_literal: true

module Mutations
  module Promotions
    class CreatePromotion < Mutations::BaseMutation
      graphql_name 'CreatePromotion'
      null true
      description 'Create new promotion'

      argument :name, String, required: true
      argument :description, String, required: true
      argument :start_datetime, String, required: true
      argument :promotion_type_id, Int, required: true
      argument :end_datetime, String, required: true
      argument :highlighted, Boolean, required: false
      argument :index, Float, required: false
      argument :active, Boolean, required: false
      argument :cost, Int, required: true
      argument :goal_quantity, Int, required: true

      field :promotion, Types::Promotions::PromotionType, null: true

      def resolve(input)
        @input = input
        @partner = context[:current_user]

        return add_error('Invalid user') unless partner.is_a?(Partner)

        promotion.save!

        { promotion: promotion }
      rescue GraphQL::ExecutionError, ActiveRecord::RecordNotFound => e
        add_error(e.to_s, extensions: { 'field' => 'root' })
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end

      private

      attr_reader :partner, :input

      def promotion
        @promotion ||= partner.promotions.build(
          name: input[:name],
          description: input[:description],
          start_datetime: input[:start_datetime],
          end_datetime: input[:end_datetime],
          highlighted: input[:highlighted],
          promotion_type_id: input[:promotion_type_id],
          index: input[:index],
          active: input[:active],
          cost: input[:cost],
          goal_quantity: input[:goal_quantity],
          partner: partner
        )
      end
    end
  end
end
