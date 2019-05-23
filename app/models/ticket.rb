# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :promotion_type
  belongs_to :partner, inverse_of: :wallet
  belongs_to :wallet, optional: true
  belongs_to :contempled_promotion, class_name: 'Promotion', foreign_key: :contempled_promotion_id, optional: true
end
