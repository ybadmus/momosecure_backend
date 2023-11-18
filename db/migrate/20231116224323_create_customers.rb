# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string(:name)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end
  end
end
