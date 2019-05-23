# frozen_string_literal: true

module Mutations
  module Tickets
    class ContemplateTicket < Mutations::BaseMutation
      attr_accessor :ticket_id, :promotion_id

      null true
      description 'Contemplate Ticket'

      argument :ticket_id, Int, required: true
      argument :promotion_id, Int, required: true

      field :success, Boolean, null: true
      field :errors, String, null: true

      def resolve(input)
        @ticket_id = input[:ticket_id]
        @promotion_id = input[:promotion_id]

        validate!

        ticket.contempled_promotion = promotion
        ticket.save!

        { ticket: true }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        { success: false, errors: e.to_s }
      end

      private

      def ticket
        @ticket ||= Ticket.find(ticket_id)
      end

      def promotion
        @promotion ||= Promotion.find(promotion_id)
      end

      def customer
        @customer ||= context[:current_user].source
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid promotion type') if promotion.promotion_type != ticket.promotion_type
        raise(GraphQL::ExecutionError, 'invalid user') if !customer.is_a?(Customer) || ticket.partner != promotion.partner || ticket&.wallet != customer.wallet
      end
    end
  end
end
