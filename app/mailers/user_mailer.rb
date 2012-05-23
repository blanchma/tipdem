# -*- encoding : utf-8 -*-
class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => Settings.notification_from, :bcc => "gauchosolitarioar@gmail.com"
  layout 'mailer'

  def payment_email(recipient,user,payment)
    @user, @payment =  user, payment
    mail(:to => recipient, :subject => "Pagar a #{user.email}")
  end

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Bienvenido a Tipdem, #{user.username}")
  end

  def recommendation_email (user,campaigns)
    @user, @campaigns = user, campaigns
    mail(:to => user.email,:subject => "Mira las nuevas campañas de Tipdem, #{user.username}"
  end

  def confirm_authentication(email,authentication)
    @user = User.find_by_email email
    @authentication = authentication
    mail(:to => email, :subject =>   "Verifique su cuenta de #{authentication.provider}")
  end

end
