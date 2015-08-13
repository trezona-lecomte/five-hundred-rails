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

ActiveRecord::Schema.define(version: 20150813045729) do

  create_table "bids", force: :cascade do |t|
    t.integer  "round_id",         limit: 4
    t.integer  "player_id",        limit: 4
    t.integer  "number_of_tricks", limit: 4
    t.integer  "suit",             limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "bids", ["player_id"], name: "index_bids_on_player_id", using: :btree
  add_index "bids", ["round_id", "number_of_tricks"], name: "index_bids_on_round_id_and_number_of_tricks", using: :btree
  add_index "bids", ["round_id"], name: "index_bids_on_round_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer  "suit",              limit: 4
    t.integer  "rank",              limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "trick_id",          limit: 4
    t.integer  "round_id",          limit: 4, null: false
    t.integer  "player_id",         limit: 4
    t.integer  "position_in_trick", limit: 4
  end

  add_index "cards", ["player_id"], name: "index_cards_on_player_id", using: :btree
  add_index "cards", ["round_id"], name: "index_cards_on_round_id", using: :btree
  add_index "cards", ["trick_id", "player_id"], name: "index_cards_on_trick_id_and_player_id", using: :btree
  add_index "cards", ["trick_id"], name: "index_cards_on_trick_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "handle",           limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "game_id",          limit: 4,   null: false
    t.integer  "user_id",          limit: 4
    t.integer  "position_in_game", limit: 4
  end

  add_index "players", ["game_id", "user_id"], name: "index_players_on_game_id_and_user_id", using: :btree
  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "game_id",        limit: 4, null: false
    t.integer  "number_in_game", limit: 4
  end

  add_index "rounds", ["game_id"], name: "index_rounds_on_game_id", using: :btree

  create_table "tricks", force: :cascade do |t|
    t.integer  "round_id",        limit: 4, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "number_in_round", limit: 4
  end

  add_index "tricks", ["round_id", "number_in_round"], name: "index_tricks_on_round_id_and_number_in_round", using: :btree
  add_index "tricks", ["round_id"], name: "index_tricks_on_round_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "access_token",           limit: 255
    t.string   "username",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "bids", "players"
  add_foreign_key "bids", "rounds"
  add_foreign_key "cards", "players"
  add_foreign_key "cards", "rounds"
  add_foreign_key "cards", "tricks"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "tricks", "rounds"
end
