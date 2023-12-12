# frozen_string_literal: true

# == Schema Information
#
# Table name: user_auths
#
#  id                :bigint           not null, primary key
#  auth_token        :string(255)
#  can_takeover_user :boolean          default(FALSE), not null
#  country_code      :string(3)        default("GH"), not null
#  email             :string(255)
#  ip_address        :string(255)
#  is_deleted        :boolean          default(FALSE), not null
#  is_phone_updated  :boolean          default(FALSE), not null
#  last_active_at    :datetime
#  locale            :string(255)      default("en")
#  login_status      :boolean          default(FALSE), not null
#  login_type        :integer
#  phone             :string(255)      default(""), not null
#  secondary_phone   :string(255)
#  status            :integer
#  user_type         :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#
# Indexes
#
#  index_user_auths_on_email_and_is_deleted            (email,is_deleted) UNIQUE
#  index_user_auths_on_phone_and_is_deleted            (phone,is_deleted) UNIQUE
#  index_user_auths_on_secondary_phone_and_is_deleted  (secondary_phone,is_deleted) UNIQUE
#
class UserAuthSerializer < ActiveModel::Serializer
  attributes :id, :phone, :email, :status, :user_type, :country_code, :locale, :login_type, :name, :last_active_at
  attribute :can_takeover_user, if: :admin?

  def name
    object&.user&.name
  end

  def admin?
    instance_options[:admin]
  end
end
