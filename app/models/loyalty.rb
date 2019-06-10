# frozen_string_literal: true

class Loyalty < ApplicationRecord
  belongs_to :customer
  belongs_to :partner

  def balance
    customer.wallet.tickets.where(partner: partner).count
  end
end
