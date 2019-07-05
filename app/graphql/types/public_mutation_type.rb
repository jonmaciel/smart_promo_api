# frozen_string_literal: true

module Types
  class PublicMutationType < Types::BaseObject
    field :create_customer, mutation: Mutations::Customers::CreateCustomer

    field :create_partner, mutation: Mutations::Partners::CreatePartner

    field :create_session, mutation: Mutations::Session::CreateSession
  end
end
