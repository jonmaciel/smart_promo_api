module Mutations
  class DeletePromotion < Mutations::BaseMutation 
    graphql_name 'DeletePromotion'
    null true
    description 'Update new partner'

    argument :id, Int, required: true

    field :success, Boolean, null: true
    field :errors, String, null: true

    def resolve(input)
      partner = context[:current_user]

      return { promotion: nil, errors: 'Invalid user' } unless partner.is_a?(Partner)

      partner.promotions.find(input[:id]).destroy!

      { success: true }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, errors: e.to_s }
    rescue ActiveRecord::ActiveRecordError => e
      { success: false, errors: e.to_s }
    end
  end
end
