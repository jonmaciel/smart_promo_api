# frozen_string_literal: true

module Mutations
  module Partners
    class UpdatePartner < Mutations::BaseMutation
      graphql_name 'UpdatePartner'
      null true
      description 'Update new partner'

      argument :id, Int, required: true
      argument :email, String, required: false
      argument :password, String, required: false
      argument :password_confirmation, String, required: false
      argument :name, String, required: false
      argument :adress, String, required: false
      argument :cnpj, String, required: false
      argument :latitude, String, required: false
      argument :longitude, String, required: false

      field :partner, Types::Partners::PartnerType, null: true

      def resolve(input)
        partner = Partner.find(input[:id])
        auth = partner.auth

        if input[:email] || input[:password]
          input[:auth_attributes] = { id: auth.id }
          input[:auth_attributes][:email] = input.delete(:email) if input[:email]
          input[:auth_attributes][:password] = input.delete(:password) if input[:password]
          input[:auth_attributes][:password_confirmation] = input.delete(:password_confirmation) if input[:email]
        end

        input.except!(:id, :email, :password, :password_confirmation)
        partner.update_attributes!(input)

        { partner: partner }
      rescue ActiveRecord::RecordNotFound => e
        add_error(e.to_s, extensions: { 'field' => 'root' })
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end
    end
  end
end
