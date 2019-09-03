# frozen_string_literal: true

class Sale < ApplicationRecord
  has_many :tickets
end
