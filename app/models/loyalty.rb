# frozen_string_literal: true

class Loyalty < ApplicationRecord
  belongs_to :customer
  belongs_to :partner
end
