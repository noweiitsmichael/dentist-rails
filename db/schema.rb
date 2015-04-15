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

ActiveRecord::Schema.define(version: 20150415054029) do

  create_table "claims", force: :cascade do |t|
    t.string   "od_uid",            limit: 255
    t.integer  "patient_id",        limit: 4
    t.datetime "service_date"
    t.datetime "sent_date"
    t.datetime "received_date"
    t.integer  "status",            limit: 4
    t.integer  "insurance_plan_id", limit: 4
    t.float    "requested_price",   limit: 24
    t.float    "payment_price",     limit: 24
    t.string   "claim_type",        limit: 255
    t.text     "open_dental_raw",   limit: 65535
    t.integer  "practice_id",       limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "dentists", force: :cascade do |t|
    t.string   "od_uid",          limit: 255
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "suffix",          limit: 255
    t.text     "open_dental_raw", limit: 65535
    t.integer  "practice_id",     limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "insurance_plans", force: :cascade do |t|
    t.string   "od_uid",          limit: 255
    t.string   "group_name",      limit: 255
    t.integer  "carrier_id",      limit: 4
    t.text     "open_dental_raw", limit: 65535
    t.integer  "practice_id",     limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "group_id",        limit: 255
    t.text     "description",     limit: 65535
  end

  create_table "patients", force: :cascade do |t|
    t.string   "od_uid",           limit: 255
    t.integer  "zipcode",          limit: 4
    t.integer  "gender",           limit: 4
    t.text     "open_dental_raw",  limit: 65535
    t.integer  "practice_id",      limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "first_visit_date"
  end

  create_table "practices", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255
    t.string   "db_username", limit: 255
    t.string   "db_password", limit: 255
    t.string   "secret_key",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "db_port",     limit: 4
    t.string   "db_host",     limit: 255
  end

  create_table "procedure_types", force: :cascade do |t|
    t.string   "od_uid",          limit: 255
    t.string   "code",            limit: 255
    t.text     "description",     limit: 65535
    t.text     "open_dental_raw", limit: 65535
    t.integer  "practice_id",     limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "procedures", force: :cascade do |t|
    t.string   "od_uid",            limit: 255
    t.integer  "patient_id",        limit: 4
    t.integer  "dentist_id",        limit: 4
    t.integer  "procedure_type_id", limit: 4
    t.integer  "claim_id",          limit: 4
    t.integer  "insurance_plan_id", limit: 4
    t.float    "price",             limit: 24
    t.integer  "status",            limit: 4
    t.datetime "date"
    t.text     "open_dental_raw",   limit: 65535
    t.integer  "practice_id",       limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
