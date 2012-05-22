# -*- encoding : utf-8 -*-
class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer   :user_id
      t.integer   :campaign_id      
      t.decimal   :money, :precision => 8, :scale => 2 , :default => 0.00
      #t.string    :status, :default => PaymentStatus::Created
      t.datetime  :paid_at
      t.text      :additional_data      
      t.timestamps
    end
  end

  def self.down
  end
end
