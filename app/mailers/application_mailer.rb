# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'yusif.badmus@gmail.com'
  layout 'mailer'

  before_action :load_logo_inline

  protected

  def load_logo_inline
    attachments.inline['logo.png'] = File.read('./app/assets/images/logo.png')
  end
end
