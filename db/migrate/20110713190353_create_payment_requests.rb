# -*- encoding : utf-8 -*-
class CreatePaymentRequests < ActiveRecord::Migration
  def self.up
    create_table :payment_requests do |t|
      t.integer   :user_id
      t.integer   :campaign_id
      t.decimal   :requested_money, :precision => 8, :scale => 2 , :default => 0.00
      t.decimal   :paid_money, :precision => 8, :scale => 2 , :default => 0.00
      t.string    :status, :default => PaymentRequestStatus::Created
      t.string    :receipt_file_name
      t.string    :receipt_content_type
      t.integer   :receipt_file_size
      t.datetime  :receipt_updated_at
    
      t.datetime  :paid_at
      t.text      :additional_data
      t.string    :mode_pay
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_requests
  end
end
