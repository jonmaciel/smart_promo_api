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
      field :errors, String, null: true

      def resolve(input)
        @quantity = input[:quantity]
        @promotion_id = input[:promotion_id]
        @cellphone_number = input[:cellphone_number]
        promotion_id = input[:promotion_id]

        validate!
        create_loyalty_if_nil!

        tickets = []

        (1..quantity).step do
          tickets << Ticket.new(
            partner: partner,
            wallet: customer.wallet,
            contempled_promotion_id: promotion_id
          )
        end

        Ticket.import tickets

        { success: true }
      rescue ActiveRecord::ActiveRecordError => e
        raise(GraphQL::ExecutionError, e.to_s)
      end

      private

      attr_accessor :cellphone_number, :promotion_id, :quantity

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
