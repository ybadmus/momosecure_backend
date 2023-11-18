# frozen_string_literal: true

module AuthenticatableConcern
  extend ActiveSupport::Concern

  included do
    has_one :user_auth, inverse_of: :user, as: :user, dependent: :destroy

    accepts_nested_attributes_for :user_auth, update_only: true
  end
end
