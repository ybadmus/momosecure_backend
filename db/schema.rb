# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_231_120_020_511) do
  create_table 'active_storage_attachments', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'admins', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.boolean 'is_deleted', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'attachments', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'attachable_type'
    t.bigint 'attachable_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[attachable_type attachable_id], name: 'index_attachments_on_attachable'
  end

  create_table 'countries', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'country_name'
    t.string 'currency', limit: 3
    t.boolean 'is_active', default: false, null: false
    t.boolean 'is_deleted', default: false, null: false
    t.string 'iso_code2', limit: 2
    t.string 'iso_code3', limit: 3
    t.string 'nationality'
    t.string 'phone_code', limit: 5
    t.decimal 'commission', precision: 10, scale: 3, default: '0.0'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['country_name'], name: 'index_countries_on_country_name', unique: true
    t.index ['iso_code2'], name: 'index_countries_on_iso_code2', unique: true
    t.index ['phone_code'], name: 'index_countries_on_phone_code', unique: true
  end

  create_table 'customers', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.boolean 'is_deleted', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'otp_bypass_user_auths', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'user_auth_id', null: false
    t.boolean 'is_deleted', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_auth_id'], name: 'index_otp_bypass_user_auths_on_user_auth_id', unique: true
  end

  create_table 'payment_transactions', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.decimal 'amount', precision: 10, scale: 3, default: '0.0'
    t.integer 'status', limit: 1, default: 1, null: false
    t.datetime 'expired_at'
    t.string 'reference_number', limit: 500, null: false
    t.decimal 'commission_fee', precision: 10, scale: 3, default: '0.0'
    t.decimal 'commission', precision: 5, scale: 3, default: '0.0'
    t.bigint 'user_auths_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['reference_number'], name: 'index_payment_transactions_on_reference_number', unique: true
    t.index ['user_auths_id'], name: 'index_payment_transactions_on_user_auths_id'
  end

  create_table 'user_auths', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'auth_token'
    t.boolean 'can_takeover_user', default: false, null: false
    t.bigint 'countries_id', null: false
    t.string 'email'
    t.string 'ip_address'
    t.boolean 'is_deleted', default: false, null: false
    t.boolean 'is_phone_updated', default: false, null: false
    t.datetime 'last_active_at'
    t.string 'locale', default: 'en'
    t.boolean 'login_status', default: false, null: false
    t.integer 'login_type', limit: 1
    t.integer 'opt_module', limit: 1
    t.string 'phone', default: '', null: false
    t.string 'secondary_phone'
    t.integer 'status', limit: 1
    t.string 'user_type'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['countries_id'], name: 'index_user_auths_on_countries_id'
    t.index ['email'], name: 'index_user_auths_on_email', unique: true
    t.index ['phone'], name: 'index_user_auths_on_phone', unique: true
    t.index ['secondary_phone'], name: 'index_user_auths_on_secondary_phone', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
end
