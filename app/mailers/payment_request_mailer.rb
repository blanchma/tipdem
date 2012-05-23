# -*- encoding : utf-8 -*-
class PaymentRequestMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => Settings.notification_from, :bcc => "gauchosolitarioar@gmail.com"
  layout 'mailer'

  def paid_email(user,payment)
    @user, @payment = user, payment
    mail(:to => user.email, :subject =>  "Tipdem te pago!")
  end

end
