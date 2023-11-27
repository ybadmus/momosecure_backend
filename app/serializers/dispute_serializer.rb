# frozen_string_literal: true

class DisputeSerializer < ActiveModel::Serializer
  attributes :id, :description, :category, :contact_number, :payment_transaction, :user_auth, :created_at, :updated_at

  def user_auth
    object.user_auth.as_json
  end

  def payment_transaction
    object.transaction.as_json
  end
end
