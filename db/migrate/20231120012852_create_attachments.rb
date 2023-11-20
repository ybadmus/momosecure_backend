# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.string(:name, null: false)
      t.references(:attachable, polymorphic: true)

      t.timestamps
    end
  end
end
