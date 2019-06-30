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

ActiveRecord::Schema.define(version: 20190607112505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "battle_members", force: :cascade do |t|
    t.string "youtube_channel_guid"
    t.string "twitter_account_name"
    t.string "photo"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_battle_members_on_user_id"
  end

  create_table "battle_votes", force: :cascade do |t|
    t.bigint "battle_id"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "battle_member_id"
    t.index ["battle_id"], name: "index_battle_votes_on_battle_id"
    t.index ["battle_member_id"], name: "index_battle_votes_on_battle_member_id"
    t.index ["user_id"], name: "index_battle_votes_on_user_id"
  end

  create_table "battles", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "first_member_id"
    t.integer "second_member_id"
    t.integer "number_of_rematch_requests", default: 0
    t.string "winner", default: ""
    t.string "status", default: "live"
    t.datetime "final_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_battles_on_slug", unique: true
    t.index ["tag_id"], name: "index_battles_on_tag_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "commentator_id"
    t.integer "video_id"
    t.integer "parent_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_comments_on_ancestry"
    t.index ["commentator_id"], name: "index_comments_on_commentator_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["video_id", "commentator_id"], name: "index_comments_on_video_id_and_commentator_id"
  end

  create_table "contribution_points", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "user_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amount"], name: "index_contribution_points_on_amount"
    t.index ["tag_id", "amount"], name: "index_contribution_points_on_tag_id_and_amount"
    t.index ["tag_id"], name: "index_contribution_points_on_tag_id"
    t.index ["user_id", "tag_id"], name: "index_contribution_points_on_user_id_and_tag_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id"
    t.json "event_object"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exception_loggers", force: :cascade do |t|
    t.text "message"
    t.string "source"
    t.string "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.string "category"
    t.json "event_object"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "rematch_requests", force: :cascade do |t|
    t.bigint "battle_id"
    t.bigint "user_id"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_rematch_requests_on_battle_id"
    t.index ["user_id"], name: "index_rematch_requests_on_user_id"
  end

  create_table "system_settings", force: :cascade do |t|
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "first_character", default: ""
    t.index ["first_character"], name: "index_tags_on_first_character"
    t.index ["rank"], name: "index_tags_on_rank"
    t.index ["slug"], name: "index_tags_on_slug", unique: true
    t.index ["title"], name: "index_tags_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "channel_name"
    t.string "slug"
    t.text "channel_description"
    t.string "avatar"
    t.integer "rank", default: 0
    t.string "role", default: "client"
    t.string "fake_avatar_url", default: ""
    t.boolean "allowed_to_send_notifications", default: true
    t.boolean "receive_notification_emails", default: true
    t.boolean "receive_promotional_emails", default: true
    t.index ["channel_name"], name: "index_users_on_channel_name", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.integer "user_id"
    t.integer "tag_id"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "cover"
    t.boolean "removed", default: false
    t.boolean "untagged", default: false
    t.string "source_id"
    t.integer "positive_votes_amount", default: 0
    t.integer "negative_votes_amount", default: 0
    t.string "twitter_handle"
    t.integer "comments_count", default: 0
    t.string "source", default: ""
    t.string "kind_of", default: ""
    t.boolean "high_quality_cover", default: false
    t.string "length"
    t.integer "duration"
    t.index ["rank"], name: "index_videos_on_rank"
    t.index ["slug"], name: "index_videos_on_slug", unique: true
    t.index ["source_id"], name: "index_videos_on_source_id"
    t.index ["tag_id"], name: "index_videos_on_tag_id"
    t.index ["url", "tag_id"], name: "index_videos_on_url_and_tag_id"
    t.index ["user_id", "tag_id"], name: "index_videos_on_user_id_and_tag_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "value"
    t.integer "video_id"
    t.integer "voter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id", "voter_id"], name: "index_votes_on_video_id_and_voter_id", unique: true
    t.index ["video_id"], name: "index_votes_on_video_id"
  end


  create_view "battle_with_title_and_members", sql_definition: <<-SQL
      SELECT battles.id,
      battles.tag_id,
      battles.first_member_id,
      battles.second_member_id,
      battles.number_of_rematch_requests,
      battles.winner,
      battles.status,
      battles.final_date,
      battles.created_at,
      battles.updated_at,
      battles.slug,
      ((((((array_agg(first_members_battles.name))[1])::text || ' vs '::text) || ((array_agg(second_members_battles.name))[1])::text) || ' '::text) || battles.id) AS custom_title,
      ((upper(((array_agg(first_members_battles.name))[1])::text) || ' vs '::text) || upper(((array_agg(second_members_battles.name))[1])::text)) AS title,
      (array_agg(first_members_battles.id))[1] AS first_members_battles_id,
      (array_agg(first_members_battles.name))[1] AS first_members_battles_name,
      (array_agg(first_members_battles.twitter_account_name))[1] AS first_members_battles_twitter_account_name,
      (array_agg(first_members_battles.photo))[1] AS first_members_battles_photo,
      count(battle_votes.id) FILTER (WHERE (battle_votes.battle_member_id = first_members_battles.id)) AS first_members_battles_voices,
      (array_agg(second_members_battles.id))[1] AS second_members_battles_id,
      (array_agg(second_members_battles.name))[1] AS second_members_battles_name,
      (array_agg(second_members_battles.twitter_account_name))[1] AS second_members_battles_twitter_account_name,
      (array_agg(second_members_battles.photo))[1] AS second_members_battles_photo,
      count(battle_votes.id) FILTER (WHERE (battle_votes.battle_member_id = second_members_battles.id)) AS second_members_battles_voices,
          CASE
              WHEN ((battles.winner)::text = ((array_agg(first_members_battles.name))[1])::text) THEN (array_agg(first_members_battles.id))[1]
              WHEN ((battles.winner)::text = ((array_agg(second_members_battles.name))[1])::text) THEN (array_agg(second_members_battles.id))[1]
              ELSE NULL::bigint
          END AS winner_members_battles_id,
          CASE
              WHEN ((battles.winner)::text = ((array_agg(first_members_battles.name))[1])::text) THEN (array_agg(first_members_battles.twitter_account_name))[1]
              WHEN ((battles.winner)::text = ((array_agg(second_members_battles.name))[1])::text) THEN (array_agg(second_members_battles.twitter_account_name))[1]
              ELSE NULL::character varying
          END AS winner_members_battles_twitter_account_name,
          CASE
              WHEN ((battles.winner)::text = ((array_agg(first_members_battles.name))[1])::text) THEN (array_agg(first_members_battles.photo))[1]
              WHEN ((battles.winner)::text = ((array_agg(second_members_battles.name))[1])::text) THEN (array_agg(second_members_battles.photo))[1]
              ELSE NULL::character varying
          END AS winner_members_battles_photo,
          CASE
              WHEN ((battles.winner)::text = ((array_agg(first_members_battles.name))[1])::text) THEN (array_agg(second_members_battles.twitter_account_name))[1]
              WHEN ((battles.winner)::text = ((array_agg(second_members_battles.name))[1])::text) THEN (array_agg(first_members_battles.twitter_account_name))[1]
              ELSE NULL::character varying
          END AS loser_members_battles_twitter_account_name,
          CASE
              WHEN ((battles.winner)::text = ((array_agg(first_members_battles.name))[1])::text) THEN count(battle_votes.id) FILTER (WHERE (battle_votes.battle_member_id = first_members_battles.id))
              WHEN ((battles.winner)::text = ((array_agg(second_members_battles.name))[1])::text) THEN count(battle_votes.id) FILTER (WHERE (battle_votes.battle_member_id = second_members_battles.id))
              ELSE NULL::bigint
          END AS winner_members_battles_voices,
          CASE
              WHEN ((battles.winner)::text = ((array_agg(first_members_battles.name))[1])::text) THEN count(battle_votes.id) FILTER (WHERE (battle_votes.battle_member_id = second_members_battles.id))
              WHEN ((battles.winner)::text = ((array_agg(second_members_battles.name))[1])::text) THEN count(battle_votes.id) FILTER (WHERE (battle_votes.battle_member_id = first_members_battles.id))
              ELSE NULL::bigint
          END AS loser_members_battles_voices
     FROM (((battles
       LEFT JOIN battle_votes ON ((battle_votes.battle_id = battles.id)))
       JOIN battle_members first_members_battles ON ((first_members_battles.id = battles.first_member_id)))
       JOIN battle_members second_members_battles ON ((second_members_battles.id = battles.second_member_id)))
    GROUP BY battles.id;
  SQL
  create_view "video_for_home_pages", sql_definition: <<-SQL
      SELECT DISTINCT ON (videos.source_id) videos.source_id,
      videos.id,
      videos.cover,
      videos.title,
      videos.source,
      videos.slug,
      users.id AS user_id,
      users.avatar AS user_avatar,
      users.channel_name AS user_channel_name,
      users.slug AS user_slug,
      tags.title AS tag_title,
      tags.slug AS tag_slug
     FROM ((videos
       JOIN users ON ((users.id = videos.user_id)))
       JOIN tags ON ((tags.id = videos.tag_id)))
    WHERE (videos.removed = false);
  SQL
  create_view "rank_for_topics", sql_definition: <<-SQL
      SELECT tags.id,
      tags.title,
      tags.rank,
      count(DISTINCT videos.id) AS video_count,
      count(votes.id) AS vote_count
     FROM ((tags
       LEFT JOIN videos ON (((videos.tag_id = tags.id) AND (videos.removed = false) AND (videos.created_at > (CURRENT_DATE - 3)))))
       LEFT JOIN votes ON ((votes.video_id = videos.id)))
    GROUP BY tags.id;
  SQL
end
