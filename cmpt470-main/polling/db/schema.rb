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

ActiveRecord::Schema.define(version: 20160411173146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "ans"
    t.integer  "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "votes"
  end

  add_index "answers", ["poll_id"], name: "index_answers_on_poll_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocks", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree

  create_table "friends", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.boolean  "accepted",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "content"
    t.string   "title"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "seen",       default: false
  end

  create_table "poll_comments", force: :cascade do |t|
    t.integer  "commenter_id"
    t.text     "body"
    t.integer  "poll_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "poll_comments", ["poll_id"], name: "index_poll_comments_on_poll_id", using: :btree

  create_table "polls", force: :cascade do |t|
    t.string   "quest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "num"
    t.string   "desc"
    t.integer  "creator_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.boolean  "accepted",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "poll_id"
    t.string  "name"
  end

  add_index "tags", ["poll_id"], name: "index_tags_on_poll_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.integer  "user_type",           default: 0
    t.integer  "contact_visibility",  default: 0
    t.integer  "response_visibility", default: 0
    t.boolean  "activated",           default: false
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
