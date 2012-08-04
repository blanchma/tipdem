class CreateRewards < ActiveRecord::Migration
  def up
    create_table :rewards do |t|
      t.integer :product_id
      t.integer :campaign_id
      t.integer :original_quantity
      t.integer :current_quantity
      t.integer :points
      t.string  :legal_conditions
      t.integer :quantity_per_user
    end

    add_index :rewards, :campaign_id
    add_index :rewards, :product_id
  end

  def down
    remove_index :rewards, :campaign_id
    remove_index :rewards, :product_id
    drop_table :rewards
  end
end
