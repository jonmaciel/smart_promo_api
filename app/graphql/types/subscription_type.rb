# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    field :new_tickets, [Types::Tickets::TicketType], null: false, description: 'A new Ticket', subscription_scope: :current_user

    def new_tickets; end
  end
end
