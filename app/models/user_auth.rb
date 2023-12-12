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
class UserAuth < ApplicationRecord
  include DestroyRecord

  audited
  has_associated_audits

  attribute :locale, :string, default: 'en'

  belongs_to :user, polymorphic: true, inverse_of: :user_auth
  has_many :transactions_as_sender, dependent: :destroy, class_name: 'PaymentTransaction', foreign_key: 'sender_user_auth_id', inverse_of: :user_auth
  has_many :transactions_as_receiver, dependent: :destroy, class_name: 'PaymentTransaction', foreign_key: 'receiver_user_auth_id', inverse_of: :user_auth

  enum status: { active: 0, inactive: 1, blocked: 2 }
  enum login_type: { sms: 0, email: 1 }

  validates :phone, :email, :secondary_phone, uniqueness: { scope: :is_deleted, allow_blank: true }
  validates :phone, presence: true, if: :sms?
  validates :email, presence: true, if: :email?
  validates :locale, inclusion: { in: %w[en] }

  def record_last_active_at!
    # If last active is not nil
    # Don't update last active until it's one minute later
    # limiting updates to once a minute per account
    update(last_active_at: Time.zone.now) if last_active_at && last_active_at < 1.minute.ago
  end

  def self.same_ip_user_blocked?(remote_ip)
    user = find_by(ip_address: remote_ip, status: 'blocked')
    return false if user.blank?

    verify_obj = CacheHandler::VerificationCode.new('user_signin_verification', user.id, user.phone)
    return true if Rails.cache.read(verify_obj.cache_key)[:user_block]

    false
  end

  def as_json(options = {})
    json = super(options)
    json[:can_takeover_user] = can_takeover_user if options[:admin]
    json[:user] = user.as_json(except: %i[is_deleted updated_at created_at])
    json
  end

  def self.unscoped_user_name(user_auth_id)
    unscoped_user_auth = UserAuth.unscoped.find_by(id: user_auth_id)
    user_type = unscoped_user_auth&.user_type
    user_id = unscoped_user_auth&.user_id
    user_type.constantize.unscoped.find_by(id: user_id)&.name
  end

  def can_takeover_user?
    admin? && can_takeover_user
  end

  def source_takeover_user
    active_target_takeover&.source_user_auth
  end

  def admin?
    user_type == 'Admin'
  end

  def customer?
    user_type == 'Customer'
  end
end
