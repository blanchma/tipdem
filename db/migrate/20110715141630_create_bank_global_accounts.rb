# -*- encoding : utf-8 -*-
class CreateBankGlobalAccounts < ActiveRecord::Migration
  def self.up
    create_table :bank_global_accounts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_global_accounts
  end
end
