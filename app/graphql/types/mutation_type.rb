module Types
  class MutationType < Types::BaseObject
    field :create_costumer, mutation: Mutations::CreateCustomer
    field :update_customer, mutation: Mutations::UpdateCustomer
    field :delete_customer, mutation: Mutations::DeleteCustomer

    field :create_partner, mutation: Mutations::CreatePartner
    field :delete_partner, mutation: Mutations::DeletePartner
    field :update_partner, mutation: Mutations::UpdatePartner

    field :create_promotion, mutation: Mutations::CreatePromotion
    field :update_promotion, mutation: Mutations::UpdatePromotion
    field :delete_promotion, mutation: Mutations::DeletePromotion
  end
end
