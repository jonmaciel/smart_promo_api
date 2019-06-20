# frozen_string_literal: true

class Loyalty < ApplicationRecord
  belongs_to :customer
  belongs_to :partner

  def balance
    customer.wallet.tickets.where(partner: partner, contempled_promotion: nil).count
  end
end
