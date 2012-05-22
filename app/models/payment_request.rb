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

