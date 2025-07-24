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

ActiveRecord::Schema[7.1].define(version: 2025_07_24_124535) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "badge_playlist_unlocks", force: :cascade do |t|
    t.integer "badge_id", null: false
    t.integer "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_badge_playlist_unlocks_on_badge_id"
    t.index ["playlist_id"], name: "index_badge_playlist_unlocks_on_playlist_id"
  end

  create_table "badges", force: :cascade do |t|
    t.string "name", null: false
    t.string "badge_type", null: false
    t.string "level", null: false
    t.integer "points_required", null: false
    t.text "description"
    t.string "icon_url"
    t.string "reward_type"
    t.text "reward_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "condition_1_type"
    t.integer "condition_1_value"
    t.string "condition_2_type"
    t.integer "condition_2_value"
    t.string "condition_3_type"
    t.integer "condition_3_value"
    t.index ["badge_type", "level"], name: "index_badges_on_badge_type_and_level", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "completed_at"
    t.index ["playlist_id"], name: "index_games_on_playlist_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "premium"
    t.string "genre"
    t.integer "points_required"
    t.boolean "exclusive"
  end

  create_table "rewards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "badge_type", null: false
    t.integer "quantity_required", null: false
    t.string "reward_type", null: false
    t.string "reward_description"
    t.boolean "unlocked", default: false
    t.datetime "unlocked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "badge_type", "quantity_required"], name: "index_rewards_on_user_badge_quantity", unique: true
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "playlist_id", null: false
    t.integer "points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_scores_on_playlist_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "swipes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "video_id", null: false
    t.integer "game_id", null: false
    t.boolean "liked", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action"
    t.integer "playlist_id"
    t.index ["game_id"], name: "index_swipes_on_game_id"
    t.index ["playlist_id"], name: "index_swipes_on_playlist_id"
    t.index ["user_id", "video_id", "game_id"], name: "index_swipes_on_user_id_and_video_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_swipes_on_user_id"
    t.index ["video_id"], name: "index_swipes_on_video_id"
  end

  create_table "user_badges", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "badge_id", null: false
    t.datetime "earned_at", null: false
    t.integer "points_at_earned", null: false
    t.boolean "reward_claimed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_user_badges_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "user_playlist_unlocks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_user_playlist_unlocks_on_playlist_id"
    t.index ["user_id"], name: "index_user_playlist_unlocks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "points"
    t.boolean "vip_subscription"
    t.datetime "vip_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "youtube_id"
    t.integer "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "points"
    t.index ["playlist_id"], name: "index_videos_on_playlist_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "badge_playlist_unlocks", "badges"
  add_foreign_key "badge_playlist_unlocks", "playlists"
  add_foreign_key "games", "playlists"
  add_foreign_key "games", "users"
  add_foreign_key "rewards", "users"
  add_foreign_key "scores", "playlists"
  add_foreign_key "scores", "users"
  add_foreign_key "swipes", "games"
  add_foreign_key "swipes", "playlists"
  add_foreign_key "swipes", "users"
  add_foreign_key "swipes", "videos"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "user_playlist_unlocks", "playlists"
  add_foreign_key "user_playlist_unlocks", "users"
  add_foreign_key "videos", "playlists"
end
