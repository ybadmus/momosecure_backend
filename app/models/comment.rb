# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id              :bigint           not null, primary key
#  attachable_type :string(255)
#  content         :text(65535)
#  is_deleted      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :bigint
#  user_auths_id   :bigint           not null
#
# Indexes
#
#  index_comments_on_attachable     (attachable_type,attachable_id)
#  index_comments_on_user_auths_id  (user_auths_id)
#
class Comment < ApplicationRecord
  include DestroyRecord

  audited associated_with: :user_auth

  belongs_to :commentable, polymorphic: true
  belongs_to :user_auth, optional: true

  validates :content, presence: true

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
end
