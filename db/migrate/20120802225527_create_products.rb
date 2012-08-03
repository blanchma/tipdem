class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :description
      t.string  :legal
      t.string  :picture_file_name
      t.string  :picture_content_type
      t.integer :picture_file_size
      t.integer :internal_stock
    end
  end
end
