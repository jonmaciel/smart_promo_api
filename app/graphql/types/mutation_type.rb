module Types
  class MutationType < Types::BaseObject
    field :create_customer, mutation: Mutations::Customers::CreateCustomer
    field :update_customer, mutation: Mutations::Customers::UpdateCustomer
    field :delete_customer, mutation: Mutations::Customers::DeleteCustomer

    field :create_partner, mutation: Mutations::Partners::CreatePartner
    field :delete_partner, mutation: Mutations::Partners::DeletePartner
    field :update_partner, mutation: Mutations::Partners::UpdatePartner

    field :create_tickets, mutation: Mutations::Tickets::CreateTickets
    field :give_ticket_to_user, mutation: Mutations::Tickets::GiveTicketToUser
    field :contemplate_ticket, mutation: Mutations::Tickets::ContemplateTicket

    field :create_promotion, mutation: Mutations::Promotions::CreatePromotion
    field :update_promotion, mutation: Mutations::Promotions::UpdatePromotion
    field :delete_promotion, mutation: Mutations::Promotions::DeletePromotion
  end
end
