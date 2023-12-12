# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_transaction_timelines
#
#  id                     :bigint           not null, primary key
#  accepted_at            :datetime
#  cancel_at              :datetime
#  dispute_at             :datetime
#  expire_at              :datetime
#  paid_at                :datetime
#  rejected_at            :datetime
#  reverse_at             :datetime
#  withheld_at            :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  payment_transaction_id :bigint           not null
#
# Indexes
#
#  index_payment_transaction_timelines_on_payment_transaction_id  (payment_transaction_id) UNIQUE
#
class PaymentTransactionTimeline < ApplicationRecord
  include DestroyRecord

  belongs_to :payment_transaction
end
