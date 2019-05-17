module Mutations
  class GiveTicketToUser < Mutations::BaseMutation 
    graphql_name 'GiveTicketToUser'
    null true
    description 'Give Ticket To User'

    argument :ticket_id, Int, required: true
    argument :cellphone_number, String, required: true

    field :success, Boolean, null: true
    field :errors, String, null: true

    def resolve(input)
      partner = context[:current_user].source

      ticket = Ticket.find(input[:ticket_id])
      customer = Auth.find_by!(cellphone_number: input[:cellphone_number]).source

      if !partner.is_a?(Partner) || !customer.is_a?(Customer) || ticket.partner != partner
        return { success: false, errors: 'invalid user' }
      end

      if Loyalty.find_by(customer: customer, partner: partner).nil?
        Loyalty.create(customer: customer, partner: partner)
      end

      ticket.wallet = customer.wallet
      ticket.save!

      { ticket: true }
    rescue ActiveRecord::ActiveRecordError => e
      { success: false, errors: e.to_s }
    end
  end
end

