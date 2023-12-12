# frozen_string_literal: true

class CreatePaymentTransactionTimeline < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_transaction_timelines do |t|
      t.references(:payment_transaction, null: false, index: { unique: true })
      t.datetime(:accepted_at)
      t.datetime(:expire_at)
      t.datetime(:rejected_at)
      t.datetime(:cancel_at)
      t.datetime(:disputed_at)
      t.datetime(:paid_at)
      t.datetime(:withheld_at)
      t.datetime(:reverse_at)

      t.timestamps
    end
  end
end
