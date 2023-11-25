# frozen_string_literal: true

class CreateDisputes < ActiveRecord::Migration[7.0]
  def change
    create_table :disputes do |t|
      t.references(:transaction, null: false)
      t.references(:user_auth, null: false)
      t.string(:category)
      t.text(:description)
      t.string(:contact_number, null: false)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end

    change_table :disputes, bulk: true do |_t|
      add_index(:disputes, %i[user_auth_id transaction_id is_deleted], unique: true)
    end
  end
end
