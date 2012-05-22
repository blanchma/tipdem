# -*- encoding : utf-8 -*-
class AddVerifyTokenToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :verify_token, :string
  end

  def self.down
    remove_column :authentications, :verify_token
  end
end
