# frozen_string_literal: true

class Country < ApplicationRecord
  include DestroyRecord

  has_many :business_accounts, dependent: :nullify
  has_many :cities, dependent: :nullify

  # #Validations
  validates :country_name, :phone_code, :iso_code2, :currency, :nationality, :vat_percentage, :vat_multiplier, :vat_fraction, presence: true
  validates :country_name, :phone_code, :iso_code2, uniqueness: true

  # #Methods

  def self.get_by_phone_code(phonecode)
    country_cache_key = "country_#{phonecode}"
    country = Rails.cache.read(country_cache_key)
    if country.blank?
      country = Country.find_by(phone_code: phonecode)

      Rails.cache.write(country_cache_key, country, expires_in: 7.days)
    end
    country
  end

  def self.get_phone_code_from_number(phone_no)
    Phoner::Phone.parse(phone_no).format('%c')
  rescue StandardError
    ''
  end

  def self.get_country_code_from_phone_code(phone_code)
    country = Country.get_by_phone_code(phone_code)
    country.present? ? country.iso_code2 : 'GH'
  end

  def vat_multiplier
    1 + vat_fraction
  end

  def vat_fraction
    vat_percentage / 100
  end
end
