# frozen_string_literal: true

module Types
  module Partners
    class PartnerType < Types::BaseObject
      description 'Partner Type'

      field :id, Int, null: true
      field :name, String, null: true
      field :adress, String, null: true
      field :cnpj, String, null: true
      field :latitude, String, null: true
      field :longitude, String, null: true
      field :cellphone_number, String, null: true, resolve: ->(obj, _, _) { obj.auth.cellphone_number }
      field :email, String, null: true, resolve: ->(obj, _, _) { obj.auth.email }
      field :partner_profile, PartnerProfileType, null: true
    end
  end
end
