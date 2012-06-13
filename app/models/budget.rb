# -*- encoding : utf-8 -*-
include ActionView::Helpers::NumberHelper

class Budget < ActiveRecord::Base

  belongs_to :campaign, :class_name => "Campaign::Base", :foreign_key => "campaign_id"

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
