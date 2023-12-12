# frozen_string_literal: true

class CreateDisputes < ActiveRecord::Migration[7.0]
  def change
    create_table :disputes do |t|
      t.references(:payment, null: false)
      t.references(:creator_user_auth, null: false, foreign_key: { to_table: 'user_auths' })
      t.references(:assignee_user_auth, null: false, foreign_key: { to_table: 'user_auths' })
      t.string(:category)
      t.text(:description)
      t.string(:contact_number, null: false)
      t.integer(:status, null: false, limit: 1, default: 1)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end

    change_table :disputes, bulk: true do |_t|
      add_index(:disputes, %i[creator_user_auth_id payment_id is_deleted], unique: true, name: 'disputes_uniqueness_index')
    end
  end
end
