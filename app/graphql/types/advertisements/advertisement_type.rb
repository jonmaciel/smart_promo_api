# frozen_string_literal: true

module Types
  module Advertisements
    class AdvertisementType < Types::BaseObject
      field :id, Int, null: true
      field :title, String, null: true
      field :description, String, null: true
      field :img_url, String, null: true
      field :start_datetime, Types::DateTimeType, null: true
      field :end_datetime, Types::DateTimeType, null: true
      field :active, Boolean, null: true

      field :partner, Types::Partners::PartnerType, null: true
    end
  end
end
