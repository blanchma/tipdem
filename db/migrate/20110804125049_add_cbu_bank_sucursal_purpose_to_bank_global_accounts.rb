# -*- encoding : utf-8 -*-
class AddCbuBankSucursalPurposeToBankGlobalAccounts < ActiveRecord::Migration
  def self.up
    add_column :bank_global_accounts, :cbu, :string
    add_column :bank_global_accounts, :bank, :string
    add_column :bank_global_accounts, :location, :string
    add_column :bank_global_accounts, :purpose, :string
    add_column :bank_global_accounts, :holder, :string
    add_column :bank_global_accounts, :money, :decimal, :precision => 8, :scale => 2 , :default => 0.00
  end

  def self.down
    remove_column :bank_global_accounts, :holder
    remove_column :bank_global_accounts, :purpose
    remove_column :bank_global_accounts, :location
    remove_column :bank_global_accounts, :bank
    remove_column :bank_global_accounts, :cbu
    remove_column :bank_global_accounts, :money
  end
end
