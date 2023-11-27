# frozen_string_literal: true

# == Schema Information
#
# Table name: disputes
#
#  id             :bigint           not null, primary key
#  category       :string(255)
#  contact_number :string(255)      not null
#  description    :text(65535)
#  is_deleted     :boolean          default(FALSE), not null
#  status         :integer          default("open"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :bigint           not null
#  user_auth_id   :bigint           not null
#
# Indexes
#
#  index_disputes_on_transaction_id                                  (transaction_id)
#  index_disputes_on_user_auth_id                                    (user_auth_id)
#  index_disputes_on_user_auth_id_and_transaction_id_and_is_deleted  (user_auth_id,transaction_id,is_deleted) UNIQUE
#
class DisputeSerializer < ActiveModel::Serializer
  attributes :id, :description, :category, :contact_number, :payment_transaction, :user_auth, :created_at, :updated_at

  def user_auth
    object.user_auth.as_json
  end

  def payment_transaction
    object.transaction.as_json
  end
end