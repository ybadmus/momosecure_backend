# frozen_string_literal: true

# == Schema Information
#
# Table name: otp_bypass_user_auths
#
#  id           :bigint           not null, primary key
#  is_deleted   :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_auth_id :bigint           not null
#
# Indexes
#
#  index_otp_bypass_user_auths_on_user_auth_id                 (user_auth_id) UNIQUE
#  index_otp_bypass_user_auths_on_user_auth_id_and_is_deleted  (user_auth_id,is_deleted) UNIQUE
#
class OtpBypassUserAuth < ApplicationRecord
  include DestroyRecord
  # audited associated_with: :user_auth

  belongs_to :user_auth

  validates :user_auth, uniqueness: { scope: :is_deleted }
end
