# frozen_string_literal: true

class PaymentTransaction < ApplicationRecord
  include DestroyRecord

  # Enum
  enum status: { under_creation: 1, pending: 2, accepted: 3, in_progress: 4, time_out: 5, rejected: 6, cancel: 7, dispute: 8, complete: 9 }

  # Relationships
  belongs_to :sender_user_auth_id, class_name: 'UserAuth'
  belongs_to :receiver_user_auth_id, class_name: 'UserAuth'

  validates :reference_number, uniqueness: true
end
