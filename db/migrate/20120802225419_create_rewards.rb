class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :product_id
      t.integer :campaign_id
      t.integer :quantity
      t.integer :points
      t.string  :special
    end
  end
end
