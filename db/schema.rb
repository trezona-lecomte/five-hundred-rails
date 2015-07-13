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

ActiveRecord::Schema.define(version: 20150713072749) do

  create_table "actions", force: :cascade do |t|
    t.integer "player_id",    limit: 4
    t.string  "action_type",  limit: 255
    t.string  "action_value", limit: 255
    t.integer "round_id",     limit: 4
  end

  add_index "actions", ["player_id"], name: "index_actions_on_player_id", using: :btree
  add_index "actions", ["round_id"], name: "index_actions_on_round_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.integer "number",    limit: 4
    t.string  "suit",      limit: 255
    t.integer "player_id", limit: 4
    t.integer "round_id",  limit: 4
  end

  add_index "bids", ["player_id"], name: "index_bids_on_player_id", using: :btree
  add_index "bids", ["round_id"], name: "index_bids_on_round_id", using: :btree

  create_table "card_collections", force: :cascade do |t|
    t.integer "player_id", limit: 4
    t.integer "round_id",  limit: 4
  end

  add_index "card_collections", ["player_id"], name: "index_card_collections_on_player_id", using: :btree
  add_index "card_collections", ["round_id"], name: "index_card_collections_on_round_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer "number",             limit: 4
    t.string  "suit",               limit: 255
    t.integer "trick_id",           limit: 4
    t.integer "card_collection_id", limit: 4
  end

  add_index "cards", ["card_collection_id"], name: "index_cards_on_card_collection_id", using: :btree
  add_index "cards", ["trick_id"], name: "index_cards_on_trick_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.text   "playing_order", limit: 65535
    t.string "last_action",   limit: 255
  end

  create_table "players", force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "game_id", limit: 4
    t.integer "number",  limit: 4
    t.integer "team_id", limit: 4
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree
  add_index "players", ["user_id", "game_id"], name: "index_players_on_user_id_and_game_id", unique: true, using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.integer "game_id",       limit: 4
    t.text    "playing_order", limit: 65535
  end

  add_index "rounds", ["game_id"], name: "index_rounds_on_game_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "number",     limit: 4
    t.integer  "game_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "teams", ["game_id"], name: "index_teams_on_game_id", using: :btree

  create_table "tricks", force: :cascade do |t|
    t.integer "round_id", limit: 4
  end

  add_index "tricks", ["round_id"], name: "index_tricks_on_round_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 255
  end

  add_foreign_key "actions", "players"
  add_foreign_key "actions", "rounds"
  add_foreign_key "bids", "players"
  add_foreign_key "bids", "rounds"
  add_foreign_key "card_collections", "players"
  add_foreign_key "card_collections", "rounds"
  add_foreign_key "cards", "card_collections"
  add_foreign_key "cards", "tricks"
  add_foreign_key "players", "games"
  add_foreign_key "players", "teams"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "teams", "games"
  add_foreign_key "tricks", "rounds"
end
