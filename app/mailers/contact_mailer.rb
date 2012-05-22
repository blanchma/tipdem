# -*- encoding : utf-8 -*-
class ContactMailer < ActionMailer::Base
  layout 'mailer'

  def contact_email(to_, message)
    recipients "#{to_}"
    bcc  "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Contactar a #{to_}"
    body :message => message, :to => _to
  end

  def approved_email(user)
    recipients user.email
    bcc  "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Su cuenta fue aprobada, #{user.username}"
    body :user => user
  end

  def payment_email(to_,user,payment)
    recipients "#{to_}"
    bcc  "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Pagar a #{user.email}"
    body :user => user, :payment => payment    
  end

  def welcome_email(user)
    recipients user.email
    bcc  "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Bienvenido a Tipdem, #{user.username}"
    body :user => user
  end

  def recommendation_email (user,campaigns)
    recipients user.email
    bcc  "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Mira las nuevas campañas de Tipdem, #{user.username}"
    body :user => user, :campaigns => campaigns
  end
  
end
