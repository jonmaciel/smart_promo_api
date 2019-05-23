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
      field :errors, String, null: true

      def resolve(input)
        partner = context[:current_user]
        return { promotion: nil, errors: 'Invalid user' } unless partner.is_a?(Partner)

        promotion = Promotion.find(input[:id])

        return { promotion: nil, errors: 'This promotion doews not belongs to context user' } unless promotion.partner == partner

        promotion.update_attributes!(input)

        { promotion: promotion }
      rescue ActiveRecord::RecordNotFound => e
        { success: false, errors: e.to_s }
      rescue ActiveRecord::ActiveRecordError => e
        { partner: nil, errors: e.to_s }
      end
    end
  end
end
