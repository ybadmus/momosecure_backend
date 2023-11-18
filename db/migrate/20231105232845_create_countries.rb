# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[7.0]
  def change
    create_table :countries do |t|
      t.string(:country_name)
      t.string(:currency, limit: 3)
      t.boolean(:is_active, default: false, null: false)
      t.boolean(:is_deleted, default: false, null: false)
      t.string(:iso_code2, limit: 2)
      t.string(:iso_code3, limit: 3)
      t.string(:nationality)
      t.string(:phone_code, limit: 5)
      t.decimal(:commission, precision: 10, scale: 3, default: 0.0)

      t.timestamps
    end

    change_table :countries, bulk: true do |_t|
      add_index(:countries, :country_name, unique: true)
      add_index(:countries, :phone_code, unique: true)
      add_index(:countries, :iso_code2, unique: true)
    end
  end
end
