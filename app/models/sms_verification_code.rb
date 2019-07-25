# frozen_string_literal: true

class SmsVerificationCode < ApplicationRecord
  def after_ten_minutes?
    ((Time.zone.now - updated_at) / 60).to_i > 10
  end
end
