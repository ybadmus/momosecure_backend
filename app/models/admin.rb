# frozen_string_literal: true

class Admin < ApplicationRecord
  include AuthenticatableConcern
  include DestroyRecord

  validates :name, presence: true
end
