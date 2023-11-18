# frozen_string_literal: false

module SmsService
  def self.send_sms_otp(mobile_no, code, appsignature = nil)
    message = "Verification Code: #{code}"
    message.concat("\n#{appsignature}") if appsignature
    if mobile_no.to_s.include?('+966')

      provider_res = false
      (1..6).each do |provider_no|
        provider_res = SmsService.send(
          "send_sms_#{Rails.application.credentials.sms["provider#{provider_no}".to_sym]}", mobile_no, message
        )
        break if provider_res != false
      end

      provider_res
    else
      providers = providers_by_country(mobile_no)

      providers.detect do |provider_no|
        sms_provider = sms_providers(provider_no)
        SmsService.send(sms_provider, mobile_no, message)
      end
    end
  end

  def self.send_sms(mobile_no, message)
    if mobile_no.to_s.include?('+966')
      mobily_res = SmsService.send_sms_mobily(mobile_no, message)
      if mobily_res == false
        twilio_res = SmsService.send_sms_twilio(mobile_no, message)
        return false if twilio_res == false
      end

      true
    else
      SmsService.send_sms_twilio(mobile_no, message)

    end
  end

  def self.send_sms_mobily(mobile_no, message)
    url = URI.parse('http://mobily.ws/api/json/')

    data = {
      'Data' => {
        'Method' => 'msgSend',
        'Params' => {
          'sender' => Rails.application.credentials.sms[:mobily_sender],
          'msg' => message,
          'numbers' => mobile_no.tr('+', ''),
          'lang' => '3',
          'applicationType' => '65'
        },
        'Auth' => {
          'mobile' => Rails.application.credentials.sms[:mobily_username],
          'password' => Rails.application.credentials.sms[:mobily_password]
        }
      }
    }

    data = JSON.generate(data)

    parsed_x = ApiCall.post_api_call_response(url:, data:, content_type: 'application/json; charset=utf-8')

    if parsed_x.present? && parsed_x['ResponseStatus'] == 'success' && parsed_x['Data'].present? && parsed_x['Data']['result'] == 1
      true
    else
      Rails.logger.warn("****Error ==> #{parsed_x['Error']} in send_sms_mobily for mobile_no==#{mobile_no}****")

      false
    end
  rescue StandardError => e
    Rails.logger.error(">>>Exception: send_sms_mobily(SmsService) - Details: mobile_no => #{mobile_no}, message => #{e}")
    false
  end

  def self.send_sms_twilio(mobile_no, message)
    TWILIO_CLIENT.api.account.messages.create(
      messaging_service_sid: Rails.application.credentials.sms[:twilio_message_sid],
      to: mobile_no,
      body: message
    )
    Rails.logger.warn("****Success ==> send_sms_twilio(SmsService) - Details: mobile_no => #{mobile_no}")
    true
  rescue Twilio::REST::RestError => e
    Rails.logger.error("****Error ==> send_sms_twilio(SmsService) - Details: mobile_no => #{mobile_no}, message => #{e}")
    false
  rescue StandardError => e
    Rails.logger.error(">>>Exception: send_sms_twilio(SmsService) - Details: mobile_no => #{mobile_no}, message => #{e}")
    false
  end

  def self.providers_by_country(mobile_no)
    phone_code = Country.get_phone_code_from_number(mobile_no)
    country = Country.get_by_phone_code(phone_code)
    if country&.iso_code2&.upcase == 'EG'
      carrier = TWILIO_CLIENT.lookups.v1.phone_numbers(mobile_no).fetch(type: ['carrier']).carrier['name']
      providers = %w[provider6 provider5 provider4]

      providers = %w[provider5 provider6 provider4] if carrier&.include?('Etisalat')

      providers
    else
      ['provider5']
    end
  end

  def self.sms_providers(provider_no)
    case provider_no
    when 'provider1'
      'send_sms_mobily'
    when 'provider2'
      'send_sms_msegat'
    when 'provider3'
      'send_sms_infobip'
    when 'provider4'
      'send_sms_unifonic'
    when 'provider5'
      'send_sms_twilio'
    when 'provider6'
      'send_sms_cequens'
    else raise ArgumentError, "Invalid SMS provider: #{provider_no}"
    end
  end
end
