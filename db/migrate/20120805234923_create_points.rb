class CreatePoints < ActiveRecord::Migration
  def up
    create_table :points do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.integer :landing_page_hit_id
      t.integer :value, :default => 0
      t.timestamps
    end

    add_index :points, [:user_id, :campaign_id]
  end

  def down
    drop_table :points
  end
end
