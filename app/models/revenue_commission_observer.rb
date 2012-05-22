# -*- encoding : utf-8 -*-
class RevenueCommissionObserver < ActiveRecord::Observer

   def after_create(comission)
    bank_account = BankGlobalAccount.instance
    bank_account.money += comission.money
    bank_account.save
  end

end
