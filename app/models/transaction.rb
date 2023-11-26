# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(10, 3)   default(0.0)
#  commission       :decimal(5, 3)    default(0.0)
#  commission_fee   :decimal(10, 3)   default(0.0)
#  expired_at       :datetime
#  is_deleted       :boolean          default(FALSE), not null
#  reference_number :string(500)      not null
#  status           :integer          default("under_creation"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_auths_id    :bigint           not null
#
# Indexes
#
#  index_transactions_on_reference_number  (reference_number) UNIQUE
#  index_transactions_on_user_auths_id     (user_auths_id)
#
class Transaction < ApplicationRecord
  include DestroyRecord

  enum status: { under_creation: 1, pending: 2, accepted: 3, in_progress: 4, expired: 5, rejected: 6, cancelled: 7, disputed: 8, paid: 9, reversed: 10, withheld: 11 }

  belongs_to :sender_user_auth, class_name: 'UserAuth'
  belongs_to :receiver_user_auth, class_name: 'UserAuth'

  validates :reference_number, uniqueness: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
end
