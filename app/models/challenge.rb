# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :promotion_type
  has_many :challenge_progresses

  def challenge_progress_by_customer(customer)
    challenge_progresses.find_by(customer: customer)
  end
end
