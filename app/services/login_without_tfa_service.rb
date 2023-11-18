# frozen_string_literal: true

class LoginWithoutTfaService
  def initialize(user_auth, remote_ip, is_main_phone)
    @user_auth = user_auth
    @appsignature = nil
    @remote_ip = remote_ip
    @is_main_phone = is_main_phone
    @phone = @is_main_phone ? @user_auth.phone : @user_auth.secondary_phone
  end

  def execute
    return temporary_blocked if user_blocked?
    return provider_error unless send_otp_code

    [:success, { tfa: false, user_auth: @user_auth }]
  end

  private

  def send_otp_code
    send_email_with_code if @user_auth.email?
    return true if Rails.env.development?

    SmsService
      .send_sms_otp(@phone, verify_object.code, @appsignature)
      .tap { |_success| send_slack_notification }
  end

  def send_slack_notification
    notifier = Slack::Notifier.new('https://hooks.slack.com/services/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', # Staging channel webhook
                                   username: 'Momo Secure Auth Code Bot')

    notifier.ping("Phone: #{@phone}\n Auth Code: #{verify_object.code}")
  end

  def send_email_with_code
    UserAuthMailer.send_otp_code(@user_auth, verify_object.code).deliver_now
  end

  def temporary_blocked
    [:error, I18n.t('temp_block_multiple_try', time_diff: verify_object.wait_time, locale: 'en')]
  end

  def provider_error
    [:error, I18n.t('problem_encountered', locale: 'en')]
  end

  def user_blocked?
    check_blocked_service.blocked?
  end

  def verify_object
    check_blocked_service.verify_object
  end

  def check_blocked_service
    @check_blocked_service ||= CheckBlockedService.new(@user_auth, @remote_ip)
  end
end
