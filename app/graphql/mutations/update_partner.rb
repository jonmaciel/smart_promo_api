module Mutations
  class UpdatePartner < Mutations::BaseMutation 
    graphql_name 'UpdatePartner'
    null true
    description 'Update new partner'

    argument :id, Int, required: false
    argument :name, String, required: false
    argument :adress, String, required: false
    argument :cnpj, String, required: false 
    argument :latitude, String, required: false
    argument :longitude, String, required: false

    field :partner, Types::PartnerType, null: true
    field :errors, [String], null: true

    def resolve(input)
      partner = Partner.find(input[:id])

      input.except(:id).each do |attribute, value|
        partner.send("#{attribute}=", value)
      end

      if partner.save
        { partner: partner }
      else
        { partner: nil, errors: partner.errors.full_messages }
      end
    end
  end
end
