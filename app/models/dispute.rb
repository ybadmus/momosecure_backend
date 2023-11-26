# frozen_string_literal: true

# == Schema Information
#
# Table name: disputes
#
#  id             :bigint           not null, primary key
#  category       :string(255)
#  contact_number :string(255)      not null
#  description    :text(65535)
#  is_deleted     :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :bigint           not null
#  user_auth_id   :bigint           not null
#
# Indexes
#
#  index_disputes_on_transaction_id                                  (transaction_id)
#  index_disputes_on_user_auth_id                                    (user_auth_id)
#  index_disputes_on_user_auth_id_and_transaction_id_and_is_deleted  (user_auth_id,transaction_id,is_deleted) UNIQUE
#
class Dispute < ApplicationRecord
  include DestroyRecord

  audited
  has_associated_audits

  belongs_to :transaction
  belongs_to :user_auth, optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :description, :contact_number, :category, presence: true
  validates :user_auth, uniqueness: { scope: %i[transaction_id is_deleted], allow_blank: true }

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
end
