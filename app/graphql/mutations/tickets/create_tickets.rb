# frozen_string_literal: true

module Mutations
  module Tickets
    class CreateTickets < Mutations::BaseMutation
      graphql_name 'CreateTicket'
      null true
      description 'Create new Ticket'

      argument :promotion_id, Int, required: false # loyalty card case!
      argument :quantity, Int, required: true
      argument :cellphone_number, String, required: true

      field :success, Boolean, null: true

      def resolve(input)
        @quantity = input[:quantity]
        @promotion_id = input[:promotion_id]
        @cellphone_number = input[:cellphone_number]
        @promotion_id = input[:promotion_id]

        validate!
        create_loyalty_if_nil!

        Ticket.import tickets

        { success: true }
      rescue GraphQL::ExecutionError, ActiveRecord::RecordNotFound => e
        add_error(e.to_s)
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end

      private

      attr_accessor :cellphone_number, :promotion_id, :quantity, :promotion_id

      def tickets
        @tickets ||= [].tap do |elements|
          1.upto(quantity) do |index|
            elements << Ticket.new(
              partner: partner,
              wallet: customer.wallet,
              cellphone_number: cellphone_number,
              contempled_promotion_id: promotion_id
            )
          end
        end
      end

      def customer
        @customer ||= Auth.find_by!(cellphone_number: cellphone_number).source
      end

      def partner
        @partner ||= context[:current_user].source
      end

      def create_loyalty_if_nil!
        return if Loyalty.find_by(customer: customer, partner: partner).present?

        Loyalty.create(customer: customer, partner: partner)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') if !partner.is_a?(Partner) || !customer.is_a?(Customer)
        raise(GraphQL::ExecutionError, '30 is the ticket limit') if quantity > 30
      end
    end
  end
end
