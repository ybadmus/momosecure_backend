# frozen_string_literal: true

class CheckBlockedService
  CACHE_ACTION = 'user_signin_verification'

  def initialize(user_auth, remote_ip)
    @user_auth = user_auth
    @remote_ip = remote_ip
  end

  def blocked?
    return true if user_blocked
    return true if UserAuth.same_ip_user_blocked?(@remote_ip)

    @user_auth.update(ip_address: '', status: 'active')
    false
  end

  def verify_object
    @verify_object ||=
      CacheHandler::VerificationCode
      .new(CACHE_ACTION, @user_auth.id, @user_auth.phone)
      .tap(&:generate_code)
  end

  private

  def user_blocked
    return false unless verify_object.user_block

    @user_auth.update(ip_address: @remote_ip, status: 'blocked')
  end
end
