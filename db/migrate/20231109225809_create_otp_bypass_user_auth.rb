# frozen_string_literal: true

class CreateOtpBypassUserAuth < ActiveRecord::Migration[7.0]
  def change
    create_table :otp_bypass_user_auths do |t|
      t.references(:user_auth, null: false, index: { unique: true })
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end

    change_table :otp_bypass_user_auths, bulk: true do |_t|
      add_index(:otp_bypass_user_auths, %i[user_auth_id is_deleted], unique: true)
    end
  end
end
