module Mutations
  module Partners
    class CreatePartner < Mutations::BaseMutation 
      graphql_name 'CreatePartner'
      null true
      description 'Create new partner'

      argument :email, String, required: true
      argument :cellphone_number, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :name, String, required: true
      argument :adress, String, required: true
      argument :cnpj, String, required: true
      argument :latitude, String, required: false
      argument :longitude, String, required: false

      field :partner, Types::Partners::PartnerType, null: true
      field :errors, String, null: true

      def resolve(input)
        partner = Partner.new(
          name: input[:name],
          adress: input[:adress],
          cnpj: input[:cnpj],
          latitude: input[:latitude],
          longitude: input[:longitude],
          auth_attributes: {
            cellphone_number: input[:cellphone_number],
            email: input[:email],
            password: input[:password],
            password_confirmation: input[:password_confirmation],
          },
          wallet_attributes: {
            code: DateTime.now.strftime('%Q')
          }
        )

        partner.save!

        { partner: partner }
      rescue ActiveRecord::ActiveRecordError => e
        { partner: nil, errors: e.to_s }
      end
    end
  end
end
