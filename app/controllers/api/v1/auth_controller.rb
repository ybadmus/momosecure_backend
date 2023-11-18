# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      before_action :get_user_auth

      # POST : /api/v1/auth/login
      def login
        status, response = AuthService.login(@user_auth, request.remote_ip, params[:tfa], @is_main_phone)
        if status == :error
          render_error(response)
        else
          render_success('success', { phone: @user_auth.phone, secondary_phone: @user_auth.secondary_phone, using_main_phone: @is_main_phone })
        end
      end

      # POST : /api/v1/auth/verify
      def verify
        auth_token = payload(@user_auth)[:auth_token]
        status, response = AuthService.verify(@user_auth, auth_token, request.remote_ip, params[:verification_code],
                                              tfa: params[:tfa])

        if status == :error
          render_error(response)
        else
          render_success('success', @user_auth.as_json) # user serializer when user auth model is created
        end
      end

      # POST : /api/v1/auth/login_with_verify
      def login_with_verify
        if params[:verification_code].present?
          auth_token = payload(@user_auth)[:auth_token]
          status, response = AuthService.verify(@user_auth, auth_token, request.remote_ip, params[:verification_code],
                                                tfa: params[:tfa])

          if status == :error
            render_error(response)
          else
            render_success('success', @user_auth.as_json)
          end
        else
          render_error("Sorry, You don't have permission to make this request.")
        end
      end

      # POST : /api/v1/auth/logout
      def logout
        status, response = AuthService.logout(@user_auth)

        if status == :error
          render_error(response)
        else
          render_success('success', response)
        end
      end

      # POST : /api/v1/auth/reset_verify_code
      def reset_verify_code
        status, response = AuthService.reset_verify_code(@user_auth, request.remote_ip, tfa: params[:tfa])

        if status == :error
          render_error(response)
        else
          render_success('success', response)
        end
      end

      protected

      def get_user_auth
        @user_auth = if params[:phone].present?
                       phone = UpdateData.format_phone_no(params[:phone])
                       user = UserAuth.find_by(phone:) || UserAuth.find_by(secondary_phone: phone)
                       if user&.phone == phone
                         @is_main_phone = true
                       elsif user&.secondary_phone == phone
                         @is_main_phone = false
                       end
                       user
                     elsif params[:email].present?
                       UserAuth.find_by!(email: params[:email])
                     else
                       UserAuth.find_by(id: params[:id])
                     end
      end

      private

      def payload(user_auth)
        return unless user_auth&.id

        { auth_token: encode({ user_id: user_auth.id.to_s }) }
      end
    end
  end
end
