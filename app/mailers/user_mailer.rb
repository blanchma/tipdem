# -*- encoding : utf-8 -*-
class UserMailer < ActionMailer::Base
  layout 'mailer'


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

  def confirm_authentication(email,authentication)
    @user = User.find_by_email email
    recipients email
    bcc  "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Verifique su cuenta de #{authentication.provider}"
    p "domain= #{APP_CONFIG['domain']}"
    body :user => @user, :authentication => authentication    
  end

end
