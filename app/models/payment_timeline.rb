# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_timelines
#
#  id          :bigint           not null, primary key
#  accepted_at :datetime
#  cancel_at   :datetime
#  disputed_at :datetime
#  expire_at   :datetime
#  paid_at     :datetime
#  rejected_at :datetime
#  reverse_at  :datetime
#  withheld_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  payments_id :bigint           not null
#
# Indexes
#
#  index_payment_timelines_on_payments_id  (payments_id) UNIQUE
#
class PaymentTimeline < ApplicationRecord
  include DestroyRecord

  belongs_to :payment
end
