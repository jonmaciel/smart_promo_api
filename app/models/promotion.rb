# frozen_string_literal: true

class Promotion < ApplicationRecord
  belongs_to :promotion_type
  belongs_to :partner, dependent: :destroy
  has_many :tickets, foreign_key: :contempled_promotion_id, inverse_of: :contempled_promotion
end
