class AddIndexesToLandingPageHits < ActiveRecord::Migration
  def up
    add_index :landing_page_hits, [:ip,:campaign_id,:user_id], unique: true
  end
end
