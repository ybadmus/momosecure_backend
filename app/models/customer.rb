# frozen_string_literal: true

class Customer < ApplicationRecord
  include AuthenticatableConcern
  include DestroyRecord

  validates :name, presence: true
end
