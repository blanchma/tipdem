# -*- encoding : utf-8 -*-
class PaymentComment < ActiveRecord::Base

  belongs_to :payment_request
end
