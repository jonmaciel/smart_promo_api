module Types
  class SubscriptionType < Types::BaseObject
    field :newTickets, Types::Tickets::TicketType, null: false, description: 'A new Ticket', subscription_scope: :current_user

    def newTickets
    end
  end
end
