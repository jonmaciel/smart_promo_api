# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode(payload, exp = 1.year.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      return unless token

      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      begin
        HashWithIndifferentAccess.new body
      rescue StandardError
        nil
      end
    end
  end
end
