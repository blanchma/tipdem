# -*- encoding : utf-8 -*-
class DineroMailAccount < ActiveRecord::Base
  belongs_to :user

  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  
end

# == Schema Information
#
# Table name: dinero_mail_accounts
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  balance    :decimal(8, 2)   default(0.0)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

