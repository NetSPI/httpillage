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

ActiveRecord::Schema.define(version: 20150726194238) do

  create_table "dictionaries", force: :cascade do |t|
    t.string   "filename"
    t.string   "original_filename"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
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

end
