module Types
  class MutationType < Types::BaseObject

    field :create_partner, mutation: Mutations::CreatePartner
    field :delete_partner, mutation: Mutations::DeletePartner
    field :update_partner, mutation: Mutations::UpdatePartner

    field :test_field, String, null: false,
      description: "An example field added by the generator"

    def test_field
      "Hello World"
    end
  end
end
