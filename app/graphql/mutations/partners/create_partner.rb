# frozen_string_literal: true

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

      def resolve(input)
        @input = input

        partner.save!

        { partner: partner }
      rescue ActiveRecord::RecordNotFound => e
        add_error(e.to_s, extensions: { 'field' => 'root' })
      rescue ActiveRecord::ActiveRecordError => e
        e.record.errors.each do |field, error|
          add_error(error, extensions: { 'field' => field.to_s })
        end

        add_error('Validation Error', extensions: { 'field' => 'root' })
      end

      private

      attr_accessor :input

      def partner
        @partner ||= Partner.new(
          name: input[:name],
          adress: input[:adress],
          cnpj: input[:cnpj],
          latitude: input[:latitude],
          longitude: input[:longitude],
          auth_attributes: {
            cellphone_number: input[:cellphone_number],
            email: input[:email],
            password: input[:password],
            password_confirmation: input[:password_confirmation]
          },
          wallet_attributes: {
            code: DateTime.now.strftime('%Q')
          }
        )
      end
    end
  end
end
