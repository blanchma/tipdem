# -*- encoding : utf-8 -*-
class PaymentRequestMailer < ActionMailer::Base
  layout 'mailer'

 
  def paid_email(user,payment)    
    recipients "#{user.email}"
    bcc "gauchosolitarioar@gmail.com"
    from NOTIFICATION_FROM
    subject  "Tipdem te pago!"
    body :user => user, :payment => payment
  end

  


  

end
