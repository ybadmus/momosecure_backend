# frozen_string_literal: true

# == Schema Information
#
# Table name: countries
#
#  id           :bigint           not null, primary key
#  commission   :decimal(10, 3)   default(0.0)
#  country_name :string(255)
#  currency     :string(3)
#  is_active    :boolean          default(FALSE), not null
#  is_deleted   :boolean          default(FALSE), not null
#  iso_code2    :string(2)
#  iso_code3    :string(3)
#  nationality  :string(255)
#  phone_code   :string(5)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_countries_on_country_name  (country_name) UNIQUE
#  index_countries_on_iso_code2     (iso_code2) UNIQUE
#  index_countries_on_phone_code    (phone_code) UNIQUE
#
class Country < ApplicationRecord
  include DestroyRecord

  validates :country_name, :phone_code, :iso_code2, :currency, :nationality, :vat_percentage, :vat_multiplier, :vat_fraction, presence: true
  validates :country_name, :phone_code, :iso_code2, uniqueness: true

  def self.get_country_by_phone_code(phone_code)
    country_cache_key = "country_#{phone_code}"
    country = Rails.cache.read(country_cache_key)
    if country.blank?
      country = find_by(phone_code:)

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
    country = get_country_by_phone_code(phone_code)
    country.present? ? country.iso_code2 : 'GH'
  end

  def vat_multiplier
    1 + vat_fraction
  end

  def vat_fraction
    vat_percentage / 100
  end
end
