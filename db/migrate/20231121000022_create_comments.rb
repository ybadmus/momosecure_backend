# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references(:user_auth, null: false)
      t.references(:commentable, polymorphic: true)
      t.boolean(:is_deleted, default: false, null: false)

      t.timestamps
    end
  end
end
