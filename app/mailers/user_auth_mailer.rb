# frozen_string_literal: true

class UserAuthMailer < ApplicationMailer
  default from: 'yusif.badmus+no-reply@yusif.co'

  def send_otp_code(user_auth, otp_code)
    @otp_code = otp_code

    mail(to: user_auth.email, subject: I18n.t('otp_code', locale: @user_auth.locale))
  rescue StandardError => e
    Rails.logger.warn("UserAuthMailer Error: #{e}")
    Sentry.set_extras(email: user_auth.email)
    Sentry.capture_message("[UserAuthMailer] Could not send otp code: #{e}")
  end

  def send_welcome_message(user_auth)
    @user_auth = user_auth
    return unless @user_auth&.email&.present?

    mail(to: @user_auth.email, subject: I18n.t('welcome_title', locale: @user_auth.locale))
  rescue StandardError => e
    Rails.logger.warn("UserAuthMailer Error: #{e}")
  end

  def send_apology_message(user)
    @user = user

    mail(to: @user.email, subject: I18n.t('apology_title', locale: @user.locale))
  rescue StandardError => e
    Rails.logger.warn("[UserAuthMailer] Could not send apology message: #{e}")
  end
end
