# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal(:amount, precision: 10, scale: 3, default: 0.0)
      t.integer(:status, null: false, limit: 1, default: 1)
      t.datetime(:expired_at)
      t.string(:reference_number, null: false, limit: 500)
      t.decimal(:commission_fee, precision: 10, scale: 3, default: 0.0)
      t.decimal(:commission, precision: 5, scale: 3, default: 0.0)
      t.references(:user_auths, null: false)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end

    add_index(:transactions, :reference_number, unique: true)
  end
end
