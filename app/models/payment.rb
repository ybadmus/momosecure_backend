# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id                    :bigint           not null, primary key
#  amount                :decimal(10, 3)   default(0.0)
#  commission            :decimal(5, 3)    default(0.0)
#  commission_fee        :decimal(10, 3)   default(0.0)
#  expired_at            :datetime
#  is_deleted            :boolean          default(FALSE), not null
#  receiver_phone        :string(255)      default(""), not null
#  reference_number      :string(500)      not null
#  sender_phone          :string(255)      default(""), not null
#  status                :integer          default("under_creation"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  receiver_user_auth_id :bigint           not null
#  sender_user_auth_id   :bigint           not null
#
# Indexes
#
#  index_payments_on_receiver_user_auth_id  (receiver_user_auth_id)
#  index_payments_on_reference_number       (reference_number) UNIQUE
#  index_payments_on_sender_user_auth_id    (sender_user_auth_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_user_auth_id => user_auths.id)
#  fk_rails_...  (sender_user_auth_id => user_auths.id)
#
class Payment < ApplicationRecord
  include DestroyRecord

  audited
  has_associated_audits

  enum status: { under_creation: 1, pending: 2, accepted: 3, in_progress: 4, expire: 5, rejected: 6, cancel: 7, disputed: 8, paid: 9, reverse: 10, withheld: 11 }

  belongs_to :sender_user_auth, class_name: 'UserAuth', optional: false
  belongs_to :receiver_user_auth, class_name: 'UserAuth', optional: true
  has_one :payment_transaction_timeline, dependent: :destroy

  after_save :record_payment_timeline

  validates :reference_number, uniqueness: true
  validates :sender_phone, :receiver_phone, :amount, presence: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  def record_payment_timeline
    Payment::TimelineService.new(payment: self).perform
  end
end
