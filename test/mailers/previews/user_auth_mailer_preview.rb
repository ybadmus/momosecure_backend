# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_auth_mailer
class UserAuthMailerPreview < ActionMailer::Preview
  def send_otp_code(_user_auth, _otp_code)
    @user_auth = UserAuth.last
    @otp_code = 1234

    UserAuthMailer.send_otp_code(@user_auth, @otp_code).deliver_now
  end
end
