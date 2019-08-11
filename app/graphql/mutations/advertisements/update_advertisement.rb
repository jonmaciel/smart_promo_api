# frozen_string_literal: true

module Mutations
  module Advertisements
    class UpdateAdvertisement < Mutations::BaseMutation
      null true

      argument :id, Int, required: false
      argument :title, String, required: false
      argument :description, String, required: false
      argument :img_url, String, required: false
      argument :start_datetime, Types::DateTimeType, required: false
      argument :end_datetime, Types::DateTimeType, required: false
      argument :active, Boolean, required: false

      field :advertisement, Types::Advertisements::AdvertisementType, null: true

      def resolve(input)
        @id = input.delete(:id)
        @input = input
        @partner = context[:current_user]

        validate!

        advertisement.update_attributes!(input)

        { advertisement: advertisement }
      rescue GraphQL::ExecutionError, ActiveRecord::RecordNotFound => e
        add_error(e.to_s)
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end

      private

      attr_reader :id, :input, :partner

      def advertisement
        @advertisement ||= Advertisement.find(id)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless partner.is_a?(Partner)
      end
    end
  end
end
