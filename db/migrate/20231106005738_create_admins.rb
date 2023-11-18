# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string(:name)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end
  end
end
