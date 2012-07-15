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

ActiveRecord::Schema.define(:version => 20120709150753) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.string   "access_token"
    t.string   "secret"
    t.string   "login"
    t.string   "name"
    t.integer  "friends"
    t.text     "auth_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "bank_global_accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cbu"
    t.string   "bank"
    t.string   "location"
    t.string   "purpose"
    t.string   "holder"
    t.decimal  "money",      :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "budgets", :force => true do |t|
    t.integer  "campaign_id"
    t.decimal  "pay_per_lead",                :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "pay_per_facebook_contact",    :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "pay_per_twitter_contact",     :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "pay_per_landing_page_hit",    :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "pay_per_client_page_hit",     :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "spent",                       :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "total",                       :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "cost",                        :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mode"
    t.integer  "commission_landing_page_hit"
    t.integer  "commission_client_page_hit"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.string   "default_message"
    t.boolean  "have_end_date"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.date     "begin_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chains", ["fish_id"], :name => "index_chains_on_fish_id"
  add_index "chains", ["fisher_id"], :name => "index_chains_on_fisher_id"

  create_table "client_page_hits", :force => true do |t|
    t.integer  "fisher_id"
    t.string   "channel"
    t.integer  "client_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "user_agent"
    t.string   "ip"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dinero_mail_accounts", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "balance",    :precision => 8, :scale => 2, :default => 0.0
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dinero_mail_global_accounts", :force => true do |t|
    t.string   "email"
    t.decimal  "balance",    :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_analytics", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "fisher_id"
    t.string   "channel"
    t.integer  "client_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
    t.string   "referrer"
    t.string   "user_agent"
  end

  add_index "landing_page_hits", ["campaign_id"], :name => "index_landing_page_hits_on_campaign_id"
  add_index "landing_page_hits", ["fisher_id"], :name => "index_landing_page_hits_on_fisher_id"
  add_index "landing_page_hits", ["ip"], :name => "index_landing_page_hits_on_ip"

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "main_image_url"
    t.string   "main_image_source"
  end

  create_table "panel_notices", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_comments", :force => true do |t|
    t.string   "user_name"
    t.string   "title"
    t.integer  "payment_request_id"
    t.boolean  "internal"
    t.text     "message"
    t.string   "type_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.decimal  "requested_money",      :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "paid_money",           :precision => 8, :scale => 2, :default => 0.0
    t.string   "status",                                             :default => "payment_request_status.created"
    t.string   "receipt_file_name"
    t.string   "receipt_content_type"
    t.integer  "receipt_file_size"
    t.datetime "receipt_updated_at"
    t.datetime "paid_at"
    t.text     "additional_data"
    t.string   "mode_pay"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dinero_mail_email"
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.decimal  "money",           :precision => 8, :scale => 2, :default => 0.0
    t.datetime "paid_at"
    t.text     "additional_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_forms", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "facebook",        :default => false
    t.datetime "last_fb_post_at"
    t.boolean  "twitter",         :default => false
    t.datetime "last_tw_post_at"
    t.boolean  "publish_daily"
    t.integer  "hour"
    t.integer  "hour_utc"
  end

  create_table "posts", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.string   "channel"
    t.string   "message"
    t.string   "status"
    t.boolean  "daily",       :default => false
    t.integer  "hour"
    t.integer  "hour_utc"
    t.string   "response"
    t.string   "post_id"
    t.integer  "attemps",     :default => 0
    t.string   "more"
    t.integer  "counter",     :default => 0
    t.string   "targets"
    t.string   "privacy"
    t.datetime "posted_at"
    t.boolean  "revenued"
    t.datetime "when_post"
    t.string   "type"
    t.integer  "retweets",    :default => 0
    t.integer  "likes",       :default => 0
    t.integer  "comments",    :default => 0
    t.boolean  "now"
  end

  create_table "promotions", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.integer  "landing_page_hits",                               :default => 0
    t.integer  "fb_posts",                                        :default => 0
    t.integer  "fb_comments",                                     :default => 0
    t.integer  "fb_likes",                                        :default => 0
    t.integer  "tw_posts",                                        :default => 0
    t.integer  "tw_retweets",                                     :default => 0
    t.integer  "count_chains",                                    :default => 0
    t.decimal  "current_money",     :precision => 8, :scale => 2, :default => 0.0
    t.integer  "current_points",                                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revenue_commissions", :force => true do |t|
    t.integer  "revenue_id"
    t.integer  "campaign_id"
    t.decimal  "money",        :precision => 8, :scale => 2, :default => 0.0
    t.string   "source_class"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revenues", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.string   "mode"
    t.decimal  "money",        :precision => 8, :scale => 2, :default => 0.0
    t.integer  "points",                                     :default => 0
    t.string   "source_class"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "states", :force => true do |t|
    t.string   "state"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statistics", :force => true do |t|
    t.string   "landingPagePath"
    t.string   "source"
    t.string   "city"
    t.datetime "date"
    t.integer  "visits"
    t.integer  "pageviews"
    t.integer  "uniquepageviews"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                    :default => "",    :null => false
    t.string   "encrypted_password",       :default => "",    :null => false
    t.string   "username"
    t.string   "locale"
    t.boolean  "chained"
    t.string   "time_zone"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "chain_id"
    t.string   "gender"
    t.date     "birthday"
    t.boolean  "admin"
    t.boolean  "approved",                 :default => false
    t.boolean  "email_recommendations",    :default => true
    t.string   "recommended_campaign_ids"
    t.boolean  "email_newsletter",         :default => true
    t.boolean  "dst"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["cached_slug"], :name => "index_users_on_cached_slug", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
