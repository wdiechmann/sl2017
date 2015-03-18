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

ActiveRecord::Schema.define(version: 20150311002438) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active",     limit: 1,   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "job_id",           limit: 4
    t.integer  "jobber_id",        limit: 4
    t.datetime "assigned_at"
    t.integer  "assignee_id",      limit: 4
    t.string   "assignee_type",    limit: 255
    t.datetime "withdrawn_at"
    t.integer  "withdrawer_id",    limit: 4
    t.string   "withdrawer_type",  limit: 255
    t.string   "withdrawn_reason", limit: 255
    t.integer  "status",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["job_id"], name: "index_assignments_on_job_id", using: :btree
  add_index "assignments", ["jobber_id"], name: "index_assignments_on_jobber_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "delivery_teams", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "ancestry",    limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobbers", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "street",             limit: 255
    t.string   "zip_city",           limit: 255
    t.string   "phone_number",       limit: 255
    t.string   "email",              limit: 255
    t.string   "confirmed_token",    limit: 255
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "jobber_assigned"
    t.datetime "next_contact_at"
    t.text     "description",        limit: 65535
    t.integer  "jobbers_controlled", limit: 4,     default: 1
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "location",         limit: 255
    t.string   "schedule",         limit: 255
    t.text     "description",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",         limit: 4,     default: 1
    t.datetime "delegated_at"
    t.integer  "jobbers_min",      limit: 4,     default: 1
    t.integer  "jobbers_wanted",   limit: 4,     default: 1
    t.integer  "jobbers_max",      limit: 4,     default: 1
    t.integer  "vacancies",        limit: 4,     default: 1
    t.datetime "promote_job_at"
    t.integer  "delivery_team_id", limit: 4
    t.integer  "user_id",          limit: 4
  end

  create_table "messages", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "name",        limit: 255
    t.string   "street",      limit: 255
    t.string   "zip_city",    limit: 255
    t.string   "email",       limit: 255
    t.string   "msg_from",    limit: 255
    t.string   "msg_to",      limit: 255
    t.text     "body",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "answered_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "role",                   limit: 4
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.integer  "account_id",             limit: 4
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
