# frozen_string_literal: true

# == Schema Information
#
# Table name: disputes
#
#  id                     :bigint           not null, primary key
#  category               :string(255)
#  contact_number         :string(255)      not null
#  description            :text(65535)
#  is_deleted             :boolean          default(FALSE), not null
#  status                 :integer          default("open"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  assignee_user_auth_id  :bigint           not null
#  creator_user_auth_id   :bigint           not null
#  payment_transaction_id :bigint           not null
#
# Indexes
#
#  disputes_uniqueness_index                 (creator_user_auth_id,payment_transaction_id,is_deleted) UNIQUE
#  index_disputes_on_assignee_user_auth_id   (assignee_user_auth_id)
#  index_disputes_on_creator_user_auth_id    (creator_user_auth_id)
#  index_disputes_on_payment_transaction_id  (payment_transaction_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_user_auth_id => user_auths.id)
#  fk_rails_...  (creator_user_auth_id => user_auths.id)
#
class DisputeSerializer < ActiveModel::Serializer
  attributes :id, :description, :category, :status, :contact_number, :transaction, :created_by, :created_at, :updated_at

  def created_by
    ActiveModelSerializers::SerializableResource.new(object.user_auth, serializer: UserAuthSerializer)
  end

  def transaction
    object.payment_transaction.as_json
  end
end
