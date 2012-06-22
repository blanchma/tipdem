# -*- encoding : utf-8 -*-
class CampaignStatusMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => Settings.notification_from, :bcc => "gauchosolitarioar@gmail.com"
  layout 'mailer'

  def paid(campaign, request=nil)
    @campaign = campaign
    mail(:to =>  "#{campaign.owner.email}",
        :subject =>  "Se pago #{campaign.name}")
  end

  def approval(campaign)
    @campaign = campaign
    mail(:to =>  "#{campaign.owner.email}",
    :subject =>  "#{campaign.name} fue aprobada")
  end

  def disapproval(campaign, message)
    @campaign, @message = campaign, message
    mail(:to => "#{campaign.owner.email}",
    :subject => "#{campaign.name} fue desaprobada")
  end


  def out_of_money(campaign)
    @campaign = campaign
    mail(:to =>  "#{campaign.owner.email}",
    :subject =>  "#{campaign.name} se quedo sin fondos")
  end


end
