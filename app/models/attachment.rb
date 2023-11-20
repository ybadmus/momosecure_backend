# frozen_string_literal: true

# == Schema Information
#
# Table name: attachments
#
#  id              :bigint           not null, primary key
#  attachable_type :string(255)
#  name            :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :bigint
#
# Indexes
#
#  index_attachments_on_attachable  (attachable_type,attachable_id)
#
class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
end
