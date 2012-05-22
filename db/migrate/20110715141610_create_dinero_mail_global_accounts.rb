# -*- encoding : utf-8 -*-
class CreateDineroMailGlobalAccounts < ActiveRecord::Migration
  def self.up
    create_table :dinero_mail_global_accounts do |t|
      t.string :email
      t.decimal :balance, :precision => 8, :scale => 2 , :default => 0.00
      t.timestamps
    end
  end

  def self.down
    drop_table :dinero_mail_global_accounts
  end
end
