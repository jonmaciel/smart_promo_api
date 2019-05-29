# frozen_string_literal: true

class ChallengeProgress < ApplicationRecord
  belongs_to :challenge
  belongs_to :customer

  def increanse_progress(quantity)
    self.progress = progress + quantity
  end
end
