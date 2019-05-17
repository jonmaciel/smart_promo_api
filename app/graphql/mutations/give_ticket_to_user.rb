module Mutations
  class GiveTicketToUser < Mutations::BaseMutation 

    attr_accessor :ticket_id, :cellphone_number, :promotion_type_id, :promotion_id

    null true
    description 'Give Ticket To User'

    argument :ticket_id, Int, required: false
    argument :promotion_id, Int, required: false # loyalty card case!
    argument :cellphone_number, String, required: true

    field :success, Boolean, null: true
    field :errors, String, null: true

    def resolve(input)
      @ticket_id = input[:ticket_id]
      @promotion_type_id = input[:promotion_type_id]
      @promotion_id = input[:promotion_id]
      @cellphone_number = input[:cellphone_number]

      validate!
      create_loyalty_if_nil!

      ticket.wallet = customer.wallet
      ticket.contempled_promotion = promotion

      ticket.save!

      { ticket: true }
    rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
      { success: false, errors: e.to_s }
    end

    private

    def ticket
      @ticket ||= ticket_id ? Ticket.find(ticket_id) : Ticket.new(promotion_type_id: promotion_type_id, partner: partner)
    end

    def validate!
      raise(GraphQL::ExecutionError, 'invalid user') if !partner.is_a?(Partner) || !customer.is_a?(Customer)
      raise(GraphQL::ExecutionError, 'invalid ticket') if ticket.partner != partner
    end

    def promotion
      @promotion ||= promotion_id ? Promotion.find(promotion_id) :nil
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

