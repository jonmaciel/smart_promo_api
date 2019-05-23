# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :source, polymorphic: true, inverse_of: :wallet
  has_many :tickets, inverse_of: :wallet
end
