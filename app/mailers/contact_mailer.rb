# -*- encoding : utf-8 -*-
class ContactMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => Settings.notification_from, :bcc => "gauchosolitarioar@gmail.com"
  layout 'mailer'

  def contact_email(recipient, message)
    @message = message
    mail(:to => "#{recipient}",  :subject =>  "Contactar a #{recipient}")
  end

  def approved_email(user)
    @user = user
    mail(:to => user.email, :subject =>  "Su cuenta fue aprobada, #{user.username}")
  end

  def payment_email(recipient,user,payment)
    @user, @payment = user, payment
    mail(:to => "#{recipient}", :subject =>  "Pagar a #{user.email}")
  end

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject =>  "Bienvenido a Tipdem, #{user.username}")
  end

  def recommendation_email (user,campaigns)
    @user, @campaigns = user, campaigns
    mail(:to => user.email, :subject =>  "Mira las nuevas campañas de Tipdem, #{user.username}")
  end

end
