# frozen_string_literal: true

# == Schema Information
#
# Table name: disputes
#
#  id                    :bigint           not null, primary key
#  category              :string(255)
#  contact_number        :string(255)      not null
#  description           :text(65535)
#  is_deleted            :boolean          default(FALSE), not null
#  status                :integer          default("open"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  assignee_user_auth_id :bigint           not null
#  creator_user_auth_id  :bigint           not null
#  payment_id            :bigint           not null
#
# Indexes
#
#  disputes_uniqueness_index                (creator_user_auth_id,payment_id,is_deleted) UNIQUE
#  index_disputes_on_assignee_user_auth_id  (assignee_user_auth_id)
#  index_disputes_on_creator_user_auth_id   (creator_user_auth_id)
#  index_disputes_on_payment_id             (payment_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_user_auth_id => user_auths.id)
#  fk_rails_...  (creator_user_auth_id => user_auths.id)
#
class Dispute < ApplicationRecord
  include DestroyRecord

  audited
  has_associated_audits

  enum status: { open: 1, close: 2 }

  belongs_to :payment
  belongs_to :creator_user_auth, class_name: 'UserAuth', optional: false
  belongs_to :assignee_user_auth, class_name: 'UserAuth', optional: true

  has_many :comments, as: :commentable, dependent: :destroy

  validates :description, :contact_number, :category, presence: true
  validates :creator_user_auth, uniqueness: { scope: %i[payment_id is_deleted], allow_blank: true }

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
end
