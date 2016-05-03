# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160503174305) do

  create_table "bruteforce_statuses", force: :cascade do |t|
    t.integer  "node_id"
    t.integer  "job_id"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charsets", force: :cascade do |t|
    t.string "key"
    t.string "val"
  end

  add_index "charsets", ["key"], name: "index_charsets_on_key"

  create_table "dictionaries", force: :cascade do |t|
    t.string   "filename"
    t.string   "original_filename"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "file_size"
    t.text     "preview"
  end

  create_table "dictionary_chunk_allocations", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "node_id"
    t.integer  "start_byte"
    t.integer  "end_byte"
    t.boolean  "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dictionary_chunk_allocations", ["job_id"], name: "index_dictionary_chunk_allocations_on_job_id"
  add_index "dictionary_chunk_allocations", ["node_id"], name: "index_dictionary_chunk_allocations_on_node_id"

  create_table "job_responses", force: :cascade do |t|
    t.integer  "jobid"
    t.text     "nodeid"
    t.integer  "code"
    t.text     "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "http_method"
    t.string   "http_uri"
    t.string   "http_host"
    t.text     "http_headers"
    t.text     "http_data"
    t.string   "attack_type"
    t.string   "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "dictionary_id"
    t.string   "attack_mode"
    t.integer  "user_id"
    t.string   "description"
    t.string   "charset"
    t.integer  "next_index"
    t.integer  "node_limit"
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id"

  create_table "node_status_checkins", force: :cascade do |t|
    t.integer  "node_id"
    t.integer  "job_id"
    t.integer  "response_code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "ip_addr"
    t.datetime "last_seen"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "mac_address"
  end

  add_index "nodes", ["mac_address"], name: "index_nodes_on_mac_address"

  create_table "response_flag_meta", force: :cascade do |t|
    t.integer  "job_id"
    t.string   "match_type"
    t.string   "match_value"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "match_delivery"
  end

  add_index "response_flag_meta", ["job_id"], name: "index_response_flag_meta_on_job_id"

  create_table "response_flags", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "node_id"
    t.string   "http_request"
    t.string   "http_response"
    t.string   "matched_string"
    t.string   "payload"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "response_flags", ["job_id"], name: "index_response_flags_on_job_id"
  add_index "response_flags", ["node_id"], name: "index_response_flags_on_node_id"

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "val"
  end

  add_index "settings", ["key"], name: "index_settings_on_key"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.string   "api_token"
    t.datetime "api_token_changed"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
