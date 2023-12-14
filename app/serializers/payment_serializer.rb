# frozen_string_literal: true

class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :commission, :commission_fee, :reference_number, :expired_at, :receiver_phone, :sender_phone, :status, :receiver_name, :sender_name, :created_at, :updated_at
  attribute :disputes, if: :show_disputes?

  def sender_name
    object.sender_user_auth.user&.name
  end

  def receiver_name
    object.receiver_user_auth&.user&.name
  end

  def disputes
    object.disputes.as_json
  end

  def show_disputes?
    instance_options[:show_disputes]
  end
end
