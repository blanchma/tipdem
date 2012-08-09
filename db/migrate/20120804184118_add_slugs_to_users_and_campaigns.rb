class AddSlugsToUsersAndCampaigns < ActiveRecord::Migration
  def up
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    add_column :campaigns, :slug, :string
    add_index :campaigns, :slug, unique: true
  end

  def down
    remove_index :users, :slug
    remove_column :users, :slug
    remove_index :campaigns, :slug
    remove_column :campaigns, :slug
  end
end
