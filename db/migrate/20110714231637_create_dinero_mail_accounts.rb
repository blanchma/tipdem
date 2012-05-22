# -*- encoding : utf-8 -*-
class CreateDineroMailAccounts < ActiveRecord::Migration
  def self.up
    create_table :dinero_mail_accounts do |t|
      t.integer :user_id
      t.decimal :balance, :precision => 8, :scale => 2 , :default => 0.00
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :dinero_mail_accounts
  end
end
