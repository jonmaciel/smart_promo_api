# frozen_string_literal: true

module Mutations
  module Tickets
    class GiveTicketToUser < Mutations::BaseMutation
      attr_accessor :ticket_id, :cellphone_number, :promotion_id

      null true
      description 'Give Ticket To User'

      argument :ticket_id, Int, required: false
      argument :promotion_id, Int, required: false # loyalty card case!
      argument :cellphone_number, String, required: true

      field :success, Boolean, null: true

      def resolve(input)
        @ticket_id = input[:ticket_id]
        @promotion_id = input[:promotion_id]
        @cellphone_number = input[:cellphone_number]

        validate!
        create_loyalty_if_nil!

        ticket.wallet = customer.wallet
        ticket.contempled_promotion = promotion

        ticket.save!

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

      def ticket
        @ticket ||= ticket_id ? Ticket.find(ticket_id) : Ticket.new(partner: partner)
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') if !partner.is_a?(Partner) || !customer.is_a?(Customer)
        raise(GraphQL::ExecutionError, 'invalid ticket') if ticket.partner != partner
      end

      def promotion
        @promotion ||= promotion_id ? Promotion.find(promotion_id) : nil
      end

      def partner
        @partner ||= context[:current_user].source
      end

      def create_loyalty_if_nil!
        return if Loyalty.find_by(customer: customer, partner: partner).present?

        Loyalty.create(customer: customer, partner: partner)
      end

      def customer
        @customer ||= Auth.find_by!(cellphone_number: cellphone_number).source
      end
    end
  end
end
