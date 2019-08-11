# frozen_string_literal: true

module Mutations
  module Advertisements
    class CreateAdvertisement < Mutations::BaseMutation
      null true

      argument :title, String, required: true
      argument :description, String, required: true
      argument :img_url, String, required: false
      argument :start_datetime, Types::DateTimeType, required: false
      argument :end_datetime, Types::DateTimeType, required: false

      field :advertisement, Types::Advertisements::AdvertisementType, null: true

      def resolve(input)
        @input = input
        @partner = context[:current_user]

        return context.add_error(GraphQL::ExecutionError.new('Invalid user')) unless partner.is_a?(Partner)

        advertisement.save!

        { advertisement: advertisement }
      rescue ActiveRecord::RecordNotFound => e
        context.add_error(GraphQL::ExecutionError.new(e.to_s, extensions: { 'field' => 'root' }))
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          context.add_error(GraphQL::ExecutionError.new(error, extensions: { 'field' => field.to_s }))
        end

        context.add_error(GraphQL::ExecutionError.new('Validation Error', extensions: { 'field' => 'root' }))
      end

      private

      attr_reader :partner, :input

      def advertisement
        @advertisement ||= partner.advertisements.build(
          title: input[:title],
          description: input[:description],
          img_url: input[:img_url],
          start_datetime: input[:start_datetime],
          end_datetime: input[:end_datetime],
          active: input[:active],
          partner: partner
        )
      end
    end
  end
end
