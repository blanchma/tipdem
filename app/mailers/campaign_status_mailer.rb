# -*- encoding : utf-8 -*-
class CampaignStatusMailer < ActionMailer::Base
layout 'mailer'

  def paid_email(campaign, request=nil)
    recipients  "#{campaign.owner.email}"
    bcc "gauchosolitarioar@gmail.com"
    from  NOTIFICATION_FROM
    subject  "Se pago #{campaign.name}"
    body :campaign => campaign, :request_url => request
  end

  def approval_email(campaign)
    recipients  "#{campaign.owner.email}"
    bcc "gauchosolitarioar@gmail.com"
    
    subject  "#{campaign.name} fue aprobada"
    body  :campaign => campaign 
  end

  def disapproval_email(campaign, message)
    recipients  "#{campaign.owner.email}"
    bcc "gauchosolitarioar@gmail.com"
    from  NOTIFICATION_FROM
    subject  "#{campaign.name} fue desaprobada"
    body  :campaign => campaign, :message => message
  end

  
  def out_of_money_email(campaign)
    recipients  "#{campaign.owner.email}"
    bcc "gauchosolitarioar@gmail.com"
    from  NOTIFICATION_FROM
    subject  "#{campaign.name} se quedo sin fondos"
    body  :campaign => campaign
  end
   

end
