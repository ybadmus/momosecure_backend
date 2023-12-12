class CreatePayment < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal(:amount, precision: 10, scale: 3, default: 0.0)
      t.integer(:status, null: false, limit: 1, default: 1)
      t.datetime(:expired_at)
      t.string(:reference_number, null: false, limit: 500)
      t.decimal(:commission_fee, precision: 10, scale: 3, default: 0.0)
      t.decimal(:commission, precision: 5, scale: 3, default: 0.0)
      t.references(:sender_user_auth, null: false, foreign_key: { to_table: 'user_auths' })
      t.references(:receiver_user_auth, null: false, foreign_key: { to_table: 'user_auths' })
      t.string(:sender_phone, default: '', null: false)
      t.string(:receiver_phone, default: '', null: false)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end

    add_index(:payments, :reference_number, unique: true)
  end
end
