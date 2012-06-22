# -*- encoding : utf-8 -*-
class PaymentRequest < ActiveRecord::Base
  attr_accessor :last_status

  belongs_to :user
  belongs_to :campaign

  has_many :payment_comments

  scope :created, :conditions => {:status => PaymentRequestStatus::Created}
  scope :paid, :conditions => {:status => PaymentRequestStatus::Paid}
  scope :in_progress, :conditions => {:status => PaymentRequestStatus::InProcess}
  scope :rejected, :conditions => {:status => PaymentRequestStatus::Rejected}

  validates_presence_of :user_id

  after_save :notify_paid_status

  def notify_paid_status
    if self.status_was != self.status && self.status == PaymentRequestStatus::Paid
      PaymentRequestMailer.delay.deliver_paid_email(user, self)
    end
  end

  def created?
    self.status == PaymentRequestStatus::Created
  end


  def in_progress!
    self.status= PaymentRequestStatus::InProcess
  end

  def in_progress?
    self.status == PaymentRequestStatus::InProcess
  end


  def paid!
    self.status= PaymentRequestStatus::Paid
  end

  def paid?
    self.status == PaymentRequestStatus::Paid
  end


  def reject!
    self.status= PaymentRequestStatus::Reject
  end

  def rejected?
    self.status == PaymentRequestStatus::Reject
  end


end


# == Schema Information
#
# Table name: payment_requests
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  campaign_id          :integer(4)
#  requested_money      :decimal(8, 2)   default(0.0)
#  paid_money           :decimal(8, 2)   default(0.0)
#  status               :string(255)     default("payment_request_status.created")
#  receipt_file_name    :string(255)
#  receipt_content_type :string(255)
#  receipt_file_size    :integer(4)
#  receipt_updated_at   :datetime
#  paid_at              :datetime
#  additional_data      :text
#  mode_pay             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  dinero_mail_email    :string(255)
#

