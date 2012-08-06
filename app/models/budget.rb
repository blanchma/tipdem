# -*- encoding : utf-8 -*-
include ActionView::Helpers::NumberHelper

class Budget < ActiveRecord::Base


  validates_numericality_of :pay_per_client_page_hit, :greater_than_or_equal_to => 0.01, :if => "mode == CampaignMode::PayPerHit"
  validates_numericality_of :pay_per_landing_page_hit, :greater_than_or_equal_to => 0.01, :if => "mode == CampaignMode::PayPerClick"
  validates_numericality_of :total, :greater_than_or_equal_to => 10

  before_create :set_commission
  after_create :set_cost


  def pay
    if mode == CampaignMode::PayPerClick
      gross_value = pay_per_landing_page_hit
      gross_value - ((gross_value * self.commission_landing_page_hit) / 100.00)
    elsif mode == CampaignMode::PayPerHit
      gross_value = pay_per_client_page_hit
      gross_value - ((gross_value * self.commission_client_page_hit) / 100.00)
    else
      0
    end
  end

  def commission
    if mode == CampaignMode::PayPerClick
      self.commission_landing_page_hit
    elsif mode == CampaignMode::PayPerHit
      self.commission_client_page_hit
    else
      1
    end
  end


  def pay_per_client_page_hit=(value)
    self[:pay_per_client_page_hit]=currency_to_number(value)
  end

  def pay_per_landing_page_hit=(value)
    self[:pay_per_landing_page_hit]=currency_to_number(value)
  end

  def total=(value)
    self[:total]=currency_to_number(value)
  end

  def current
    self.total - self.spent
  end

  def set_cost
    self.cost = total
  end

  def set_commission
    self.commission_landing_page_hit = Commission::LandingPageHit
    self.commission_client_page_hit = Commission::ClientPageHit
  end

  private
  def currency_to_number(value)
    value.delete!(I18n.t "number.currency.format.unit")
    value.delete!(".")
    value.gsub!(",", ".")
    value.delete!(" ")
    value
  end

end

# == Schema Information
#
# Table name: budgets
#
#  id                          :integer(4)      not null, primary key
#  campaign_id                 :integer(4)
#  pay_per_lead                :decimal(8, 2)   default(0.0)
#  pay_per_facebook_contact    :decimal(8, 2)   default(0.0)
#  pay_per_twitter_contact     :decimal(8, 2)   default(0.0)
#  pay_per_landing_page_hit    :decimal(8, 2)   default(0.0)
#  pay_per_client_page_hit     :decimal(8, 2)   default(0.0)
#  spent                       :decimal(8, 2)   default(0.0)
#  total                       :decimal(8, 2)   default(0.0)
#  cost                        :decimal(8, 2)   default(0.0)
#  created_at                  :datetime
#  updated_at                  :datetime
#  mode                        :string(255)
#  commission_landing_page_hit :integer(4)
#  commission_client_page_hit  :integer(4)
#

