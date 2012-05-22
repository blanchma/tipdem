# -*- encoding : utf-8 -*-
class CreatePaymentComments < ActiveRecord::Migration
  def self.up
    create_table :payment_comments do |t|
      t.string   :user_name
      t.string   :title
      t.integer  :payment_request_id
      t.boolean  :internal
      t.text     :message
      t.string   :type_message
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_comments
  end
end
