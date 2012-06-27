# -*- encoding : utf-8 -*-
class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.column :user_id,         :integer
      t.column :name,            :string
      t.column :description,     :string
      t.column :current_status,  :string
      t.column :default_message, :string
      t.column :mode,            :integer
      t.column :have_end_date, :boolean
      t.column :logo_file_name,    :string
      t.column :logo_content_type, :string
      t.column :logo_file_size,  :integer
      t.column :begin_date , :date
      t.column :end_date , :date
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
