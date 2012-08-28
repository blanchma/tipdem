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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120805234923) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.string   "secret"
    t.string   "login"
    t.string   "name"
    t.integer  "friends_count"
    t.text     "auth_hash"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "followers_count"
    t.integer  "following_count"
    t.string   "type"
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "campaigns", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "current_status"
    t.string   "default_message"
    t.integer  "mode"
    t.boolean  "have_end_date"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.date     "begin_date"
    t.date     "end_date"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "legal_terms"
    t.string   "slug"
  end

  add_index "campaigns", ["slug"], :name => "index_campaigns_on_slug", :unique => true

  create_table "campaigns_notifieds", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "campaign_id"
  end

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "categories_campaigns", :id => false, :force => true do |t|
    t.integer "campaign_id"
    t.integer "category_id"
  end

  create_table "categories_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "category_id"
  end

  create_table "chains", :force => true do |t|
    t.integer  "fisher_id"
    t.integer  "fish_id"
    t.integer  "campaign_id"
    t.integer  "baits",       :default => 5
    t.string   "channel"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "chains", ["fish_id"], :name => "index_chains_on_fish_id"
  add_index "chains", ["fisher_id"], :name => "index_chains_on_fisher_id"

  create_table "facebook_analytics", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "facebook_groups", :force => true do |t|
    t.integer "user_id"
    t.integer "authentication_id"
    t.string  "group_id"
  end

  create_table "facebook_pages", :force => true do |t|
    t.integer "user_id"
    t.integer "authentication_id"
    t.string  "page_id"
  end

  create_table "landing_page_hits", :force => true do |t|
    t.integer  "user_id"
    t.string   "channel"
    t.integer  "campaign_id"
    t.string   "referrer"
    t.string   "ip"
    t.string   "user_agent"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "landing_page_hits", ["ip", "campaign_id", "user_id"], :name => "index_landing_page_hits_on_ip_and_campaign_id_and_user_id", :unique => true

  create_table "landing_pages", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "template_id"
    t.string   "title"
    t.string   "sub_title"
    t.text     "body"
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.string   "owner_url"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "main_image_url"
    t.string   "main_image_source"
  end

  create_table "points", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.integer  "landing_page_hit_id"
    t.integer  "value",               :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "points", ["user_id", "campaign_id"], :name => "index_points_on_user_id_and_campaign_id"

  create_table "posts", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.string   "channel"
    t.string   "message"
    t.boolean  "now"
    t.string   "status"
    t.boolean  "daily",       :default => false
    t.integer  "hour"
    t.integer  "hour_utc"
    t.string   "response"
    t.string   "post_id"
    t.integer  "attemps",     :default => 0
    t.string   "more"
    t.integer  "counter",     :default => 0
    t.datetime "when_post"
    t.datetime "posted_at"
    t.boolean  "removed"
    t.integer  "retweets",    :default => 0
    t.integer  "likes",       :default => 0
    t.integer  "comments",    :default => 0
  end

  add_index "posts", ["hour_utc"], :name => "index_posts_on_hour_utc"
  add_index "posts", ["posted_at"], :name => "index_posts_on_posted_at"
  add_index "posts", ["user_id", "campaign_id"], :name => "index_posts_on_user_id_and_campaign_id"
  add_index "posts", ["when_post"], :name => "index_posts_on_when_post"

  create_table "products", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "legal"
    t.string  "picture_file_name"
    t.string  "picture_content_type"
    t.integer "picture_file_size"
    t.integer "internal_stock"
  end

  create_table "promotions", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.integer  "current_points", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "promotions", ["user_id", "campaign_id"], :name => "index_promotions_on_user_id_and_campaign_id"

  create_table "rewards", :force => true do |t|
    t.integer "product_id"
    t.integer "campaign_id"
    t.integer "initial_stock"
    t.integer "current_stock"
    t.integer "points"
    t.string  "legal_conditions"
    t.boolean "unique"
  end

  add_index "rewards", ["campaign_id"], :name => "index_rewards_on_campaign_id"
  add_index "rewards", ["product_id"], :name => "index_rewards_on_product_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                    :default => "",    :null => false
    t.string   "encrypted_password",       :default => "",    :null => false
    t.string   "username"
    t.string   "locale"
    t.boolean  "chain_id"
    t.string   "time_zone"
    t.string   "gender"
    t.date     "birthday"
    t.boolean  "admin"
    t.boolean  "approved",                 :default => false
    t.boolean  "dst"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "email_recommendations",    :default => true
    t.string   "recommended_campaign_ids"
    t.boolean  "email_newsletter",         :default => true
    t.boolean  "terms_approved"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
