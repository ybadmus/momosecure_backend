# frozen_string_literal: true

class OtpBypassUserAuth < ApplicationRecord
  include DestroyRecord
  # audited associated_with: :user_auth

  # Relationships
  belongs_to :user_auth

  # Validations
  validates :user_auth, uniqueness: { scope: :is_deleted }
end
