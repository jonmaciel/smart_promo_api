module Mutations
  module Tickets 
    class CreateTickets < Mutations::BaseMutation 
      graphql_name 'CreateTicket'
      null true
      description 'Create new Ticket'

      argument :quantity, Int, required: true
      argument :promotion_type_id, Int, required: true

      field :success, Boolean, null: true
      field :errors, String, null: true

      def resolve(input)
        partner = context[:current_user].source
        quantity = input[:quantity]

        return { success: false, errors: 'invalid user' } unless partner.is_a?(Partner)
        return { succes: false, errors: '30 is the ticket limit' } if quantity > 30

        tickets = []

        1..quantity.times do
          tickets << Ticket.new(
            promotion_type_id: input[:promotion_type_id],
            partner: partner
          )
        end

        Ticket.import tickets

        { ticket: true }
      rescue ActiveRecord::ActiveRecordError => e
        { success: false, errors: e.to_s }
      end
    end
  end
end
