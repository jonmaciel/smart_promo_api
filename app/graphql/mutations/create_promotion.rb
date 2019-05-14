module Mutations
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

    field :promotion, Types::PromotionType, null: true
    field :errors, String, null: true

    def resolve(input)
      partner = context[:current_user]
      return { promotion: nil, errors: 'Invalid user' } unless partner.is_a?(Partner)

      promotion = partner.promotions.build(
        name: input[:name],
        description: input[:description],
        start_datetime: input[:start_datetime],
        end_datetime: input[:end_datetime],
        highlighted: input[:highlighted],
        promotion_type_id: input[:promotion_type_id],
        index: input[:index],
        active: input[:active],
        partner: partner
      )

      promotion.save!

      { promotion: promotion }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, errors: e.to_s }
    rescue ActiveRecord::ActiveRecordError => e
      { partner: nil, errors: e.to_s }
    end
  end
end
