# frozen_string_literal: true

# == Schema Information
#
# Table name: disputes
#
#  id                     :bigint           not null, primary key
#  category               :string(255)
#  contact_number         :string(255)      not null
#  description            :text(65535)
#  is_deleted             :boolean          default(FALSE), not null
#  status                 :integer          default("open"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  payment_transaction_id :bigint           not null
#  user_auth_id           :bigint           not null
#
# Indexes
#
#  dispute_uniqueness_index                  (user_auth_id,payment_transaction_id,is_deleted) UNIQUE
#  index_disputes_on_payment_transaction_id  (payment_transaction_id)
#  index_disputes_on_user_auth_id            (user_auth_id)
#
class Dispute < ApplicationRecord
  include DestroyRecord

  audited
  has_associated_audits

  enum status: { open: 1, close: 2 }

  belongs_to :payment_transaction
  belongs_to :user_auth, optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :description, :contact_number, :category, presence: true
  validates :user_auth, uniqueness: { scope: %i[payment_transaction_id is_deleted], allow_blank: true }

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
end
