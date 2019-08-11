# frozen_string_literal: true

module Mutations
  module Partners
    class DeletePartner < Mutations::BaseMutation
      graphql_name 'DeletePartner'
      null true
      description 'Update new partner'

      argument :id, Int, required: true

      field :success, Boolean, null: true

      def resolve(id:)
        { success: Partner.find(id).destroy! }
      rescue ActiveRecord::RecordNotFound => e
        add_error(e.to_s, extensions: { 'field' => 'root' })
      end
    end
  end
end
