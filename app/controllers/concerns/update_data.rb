# frozen_string_literal: true

module UpdateData
  extend ActiveSupport::Concern

  def self.quote_param(param)
    ActiveRecord::Base.connection.quote(param)
  end

  def self.clean_no(number)
    number.gsub(/[^0-9.]/, '')
  end

  def self.format_phone_no(number)
    return '' if number.blank?

    number = number.gsub(/[^+0-9]/, '')
    number = "+#{number}" if number[0] != '+'
    number
  end
end
