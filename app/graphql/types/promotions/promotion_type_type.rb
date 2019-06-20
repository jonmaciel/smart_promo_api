# frozen_string_literal: true

module Types
  module Promotions
    class PromotionTypeType < Types::BaseObject
      graphql_name 'PromotionType'
      description 'Promotion Type'

      field :id, Int, null: true
      field :label, String, null: true
      field :slug, String, null: true
    end
  end
end
