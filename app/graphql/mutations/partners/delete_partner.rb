module Mutations
  module Partners
    class DeletePartner < Mutations::BaseMutation 
      graphql_name 'DeletePartner'
      null true
      description 'Update new partner'

      argument :id, Int, required: true

      field :success, Boolean, null: true
      field :errors, String, null: true

      def resolve(input)
        partner = Partner.find(input[:id])

        { success: partner.destroy! }
      rescue ActiveRecord::RecordNotFound => e
        { success: false, errors: e.to_s }
      rescue ActiveRecord::ActiveRecordError => e
        { success: false, errors: e.to_s }
      end
    end
  end
end
