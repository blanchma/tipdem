# -*- encoding : utf-8 -*-
class AddDineroMailEmailToPaymentRequests < ActiveRecord::Migration
  def self.up
    add_column :payment_requests, :dinero_mail_email, :string
  end

  def self.down
    remove_column :payment_requests, :dinero_mail_email
  end
end
