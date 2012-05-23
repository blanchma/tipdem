# -*- encoding : utf-8 -*-
class CampaignStatusMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => Settings.notification_from, :bcc => "gauchosolitarioar@gmail.com"
  layout 'mailer'

  def paid_email(campaign, request=nil)
    @campaign = campaign
    mail(:to =>  "#{campaign.owner.email}",
        :subject =>  "Se pago #{campaign.name}")
  end

  def approval_email(campaign)
    @campaign = campaign
    mail(:to =>  "#{campaign.owner.email}",
    :subject =>  "#{campaign.name} fue aprobada")
  end

  def disapproval_email(campaign, message)
    @campaign, @message = campaign, message
    mail(:to => "#{campaign.owner.email}",
    :subject => "#{campaign.name} fue desaprobada")
  end


  def out_of_money_email(campaign)
    @campaign = campaign
    mail(:to =>  "#{campaign.owner.email}",
    :subject =>  "#{campaign.name} se quedo sin fondos")
  end


end
