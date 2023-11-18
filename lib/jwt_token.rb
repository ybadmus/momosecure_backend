# frozen_string_literal: true

module JwtToken
  def encode(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end

  def decode(token)
    ActiveSupport::HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })[0])
  rescue StandardError
    nil
  end
end
