# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(10, 3)   default(0.0)
#  commission       :decimal(5, 3)    default(0.0)
#  commission_fee   :decimal(10, 3)   default(0.0)
#  expired_at       :datetime
#  reference_number :string(500)      not null
#  status           :integer          default("under_creation"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_auths_id    :bigint           not null
#
# Indexes
#
#  index_payment_transactions_on_reference_number  (reference_number) UNIQUE
#  index_payment_transactions_on_user_auths_id     (user_auths_id)
#
class PaymentTransaction < ApplicationRecord
  include DestroyRecord

  # Enum
  enum status: { under_creation: 1, pending: 2, accepted: 3, in_progress: 4, time_out: 5, rejected: 6, cancel: 7, dispute: 8, complete: 9 }

  # Relationships
  belongs_to :sender_user_auth_id, class_name: 'UserAuth'
  belongs_to :receiver_user_auth_id, class_name: 'UserAuth'
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :reference_number, uniqueness: true
end
