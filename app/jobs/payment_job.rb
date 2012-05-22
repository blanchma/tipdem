# -*- encoding : utf-8 -*-
class PaymentJob < Struct.new(:user,:payment)  
   def perform 
    
     ContactMailer::deliver_payment_email(user,payment)
     #mailing = Mailing.find(mailing_id)  
     #mailing.deliver  
   end  
end 
