# frozen_string_literal: true

# Service to handle login logic for any user that has UserAuth association(i.e. user_auth_id)
class AuthService
  def self.login(user_auth, remote_ip, tfa, is_main_phone)
    return [:error, I18n.t('phone_not_exists', locale: 'en')] if user_auth.blank?

    if user_auth.otp_module_disabled? || tfa == 'false'
      LoginWithoutTfaService.new(user_auth, remote_ip, is_main_phone).execute
    else
      [:success, { tfa: true, user_auth: }]
    end
  end

  def self.verify(user_auth, auth_token, remote_ip, verification_code, tfa: 'false', is_main_phone: true)
    return :error, I18n.t('phone_not_exists', locale: 'en') if user_auth.blank?

    phone = is_main_phone ? user_auth.phone : user_auth.secondary_phone

    verification_code = UpdateData.clean_no(verification_code) if verification_code.present?

    if tfa == 'false'
      # #Verify user using cache library
      verify_object = CacheHandler::VerificationCode.new('user_signin_verification', user_auth.id, phone)
      verify_object.verify_code(verification_code)

      # #Check if user is blocked due to multiple tries.
      if verify_object.user_block
        user_auth.update(ip_address: remote_ip, status: 'blocked')
        error = I18n.t('temp_block_multiple_try', time_diff: verify_object.wait_time, locale: 'en')
        return :error, error
      elsif UserAuth.same_ip_user_blocked?(remote_ip)
        error = I18n.t('temp_block_multiple_try', time_diff: verify_object.wait_time, locale: 'en')
        return :error, error
      else
        user_auth.update(ip_address: '', status: 'active')
      end

      # Check if code matches
      if verify_object.code_match
        authentication_success = true
        # udpate country_code
        country_phone_code = Country.get_phone_code_from_number(phone)
        country_code = Country.get_country_code_from_phone_code(country_phone_code)
        user_auth.update(country_code:)

        # Delete cache on successful verification
        verify_object.delete_code

      # skip validation for these numbers and skip all validation when you are in Dev environment
      elsif OtpBypassUserAuth.find_by(user_auth:).present? || Rails.env.development?
        authentication_success = true
        # udpate country_code
        country_phone_code = Country.get_phone_code_from_number(phone)
        country_code = Country.get_country_code_from_phone_code(country_phone_code)

        user_auth.update(country_code:)
      else
        authentication_success = false
        invalid_code_error_message = I18n.t('invalid_code_with_try_left', tries_left: verify_object.tries_left, locale: 'en')
      end
    end

    if authentication_success
      user_auth.update!(auth_token:, login_status: true, last_active_at: Time.zone.now.to_s)
      [:success, { user_auth: }]
    else
      [:error, invalid_code_error_message]
    end
  end

  def self.logout(user_auth)
    if user_auth.blank?
      error = I18n.t('phone_not_exists', locale: 'en')
      return :error, error
    end

    user_auth.update(login_status: false, auth_token: '')

    [:success, { user_auth: }]
  end

  def self.reset_verify_code(user_auth, remote_ip, tfa: 'false', is_main_phone: true)
    if user_auth.blank?
      error = I18n.t('phone_not_exists', locale: 'en')
      return :error, error
    end

    phone = is_main_phone ? user_auth.phone : user_auth.secondary_phone

    # #Authenticate using sms cache verification system if tfa is disabled or user wants sms authentication
    if user_auth.otp_module_disabled? || tfa == 'false'

      # #Create verification code cache
      verify_object = CacheHandler::VerificationCode.new('user_signin_verification', user_auth.id, phone, 5, 5, 6)

      # #Delete cache
      verify_object.delete_code

      # #Generate cache
      verify_object.generate_code

      # #Check if user is blocked due to multiple tries.
      if verify_object.user_block
        user_auth.update(ip_address: remote_ip, status: 'blocked')
        error = I18n.t('temp_block_multiple_try', time_diff: verify_object.wait_time, locale: 'en')
        return :error, error
      elsif UserAuth.same_ip_user_blocked?(remote_ip)
        error = I18n.t('temp_block_multiple_try', time_diff: verify_object.wait_time, locale: 'en')
        return :error, error
      else
        user_auth.update(ip_address: '', status: 'active')
      end

      # Verify Mobile Number and send SMS
      code = verify_obj.code

      send_email_with_code if @user_auth.email?
      return [:success, { tfa: false, user_auth: }] if Rails.env.development?

      if SmsService.send_sms_otp(phone, code)
        send_slack_notification
        [:success, { tfa: false, user_auth: }]
      else
        error = I18n.t('problem_encountered', locale: 'en')
        [:error, error]
      end
    else
      # #Code to be added from authenticator app
      [:success, { tfa: true, user_auth: }]
    end
  end

  def self.send_email_with_code
    UserAuthMailer.send_otp_code(@user_auth, verify_object.code).deliver_now
  end
end
