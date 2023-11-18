# frozen_string_literal: true

class CreateUserAuths < ActiveRecord::Migration[7.0]
  def change
    create_table :user_auths do |t|
      t.string(:auth_token)
      t.boolean(:can_takeover_user, default: false, null: false)
      t.references(:countries, null: false)
      t.string(:email)
      t.string(:ip_address)
      t.boolean(:is_deleted, default: false, null: false)
      t.boolean(:is_phone_updated, default: false, null: false)
      t.datetime(:last_active_at)
      t.string(:locale, default: 'en')
      t.boolean(:login_status, default: false, null: false)
      t.integer(:login_type, limit: 1)
      t.integer(:opt_module, limit: 1)
      t.string(:phone, default: '', null: false)
      t.string(:secondary_phone)
      t.integer(:status, limit: 1)
      t.string(:user_type)
      t.integer(:user_id)

      t.timestamps
    end

    change_table :user_auths, bulk: true do |_t|
      add_index(:user_auths, :phone, unique: true)
      add_index(:user_auths, :email, unique: true)
      add_index(:user_auths, :secondary_phone, unique: true)
    end
  end
end
