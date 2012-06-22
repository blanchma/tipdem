# -*- encoding : utf-8 -*-
class DineroMailGlobalAccount < ActiveRecord::Base
end

# == Schema Information
#
# Table name: dinero_mail_global_accounts
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  balance    :decimal(8, 2)   default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

