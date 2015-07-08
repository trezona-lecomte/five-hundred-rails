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

ActiveRecord::Schema.define(version: 20150708044450) do

  create_table "card_collections", force: :cascade do |t|
    t.integer  "player_id",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "round_id",       limit: 4
    t.integer  "round_kitty_id", limit: 4
  end

  add_index "card_collections", ["player_id"], name: "index_card_collections_on_player_id", using: :btree
  add_index "card_collections", ["round_id"], name: "index_card_collections_on_round_id", using: :btree
  add_index "card_collections", ["round_kitty_id"], name: "index_card_collections_on_round_kitty_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "suit",               limit: 255
    t.integer  "number",             limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "trick_id",           limit: 4
    t.integer  "card_collection_id", limit: 4
  end

  add_index "cards", ["card_collection_id"], name: "index_cards_on_card_collection_id", using: :btree
  add_index "cards", ["trick_id"], name: "index_cards_on_trick_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games_players", id: false, force: :cascade do |t|
    t.integer "game_id",   limit: 4
    t.integer "player_id", limit: 4
  end

  add_index "games_players", ["game_id"], name: "index_games_players_on_game_id", using: :btree
  add_index "games_players", ["player_id"], name: "index_games_players_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "game_id",    limit: 4
  end

  add_index "rounds", ["game_id"], name: "index_rounds_on_game_id", using: :btree

  create_table "tricks", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "round_id",   limit: 4
  end

  add_index "tricks", ["round_id"], name: "index_tricks_on_round_id", using: :btree

  add_foreign_key "card_collections", "players"
  add_foreign_key "card_collections", "rounds"
  add_foreign_key "cards", "card_collections"
  add_foreign_key "cards", "tricks"
  add_foreign_key "rounds", "games"
  add_foreign_key "tricks", "rounds"
end
