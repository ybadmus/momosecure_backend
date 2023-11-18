# frozen_string_literal: true

module UserAuthentication
  protected

  def authenticate_request!
    unless user_id_in_token?
      render_unauthorized('INVALID_TOKEN')
      return
    end
    set_current_user!
  rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound, RuntimeError
    render_unauthorized('INVALID_TOKEN')
    nil
  rescue StandardError
    render_unauthorized('Not Authorized')
    nil
  end

  def set_current_user!
    user_auth = UserAuth.include(:user).find(auth_token[:user_id])
    raise 'INVALID_TOKEN' if user_auth.auth_token != http_token

    @audited_user = user_auth
    @admin_user = user_auth if user_auth.admin?
    @current_user = user_auth

    # @current_user can be null if target user is deleted during takeover session
    if @current_user.present?
      Sentry.set_user({ id: @current_user.id, name: @current_user.user.try(:name), email: @current_user.email,
                        phone: @current_user.phone, user_type: @current_user.user_type }.select do |_, v|
                        v.present?
                      end)

      @current_user.record_last_active_at!
    end
    @current_user
  end

  def optional_authenticate_request!
    authenticate_request! if user_id_in_token?
  end

  def authenticate_integration_or_user_request!
    if integration_token?
      @current_user = SystemUser.mrsool_partner_integration
    elsif user_id_in_token?
      authenticate_request!
    elsif http_api_key?
      authenticate_mrsool_request!
    else
      render_unauthorized('Not Authorized')
    end
  end

  def authenticate_api_request!
    unless api_token?
      render_unauthorized('Not Authenticated')
      return
    end
    @current_user = SystemUser.mrsool_app
  rescue StandardError
    render_unauthorized('Not Authorized')
    nil
  end

  def authenticate_mrsool_request!
    unless http_api_key?
      render_unauthorized('Not Authenticated')
      return
    end
    @current_user = SystemUser.mrsool_backend
  rescue StandardError
    render_unauthorized('Not Authorized')
    nil
  end

  def http_token
    @http_token ||= (request.headers['Authorization'].split.last if request.headers['Authorization'].present?)
  end

  private

  def http_api_key
    @http_api_key ||= (request.headers['HTTP_API_KEY'].split.last if request.headers['HTTP_API_KEY'].present?)
  end

  def auth_token
    @auth_token ||= decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].present?
  end

  def api_token?
    http_token == Rails.application.credentials.api_token
  end

  def integration_token?
    http_token == Rails.application.credentials.dig(:api, :integration, :auth_token)
  end

  def http_api_key?
    http_api_key == Rails.application.credentials.mrsool_api_key
  end
end
