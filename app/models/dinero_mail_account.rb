# -*- encoding : utf-8 -*-
class DineroMailAccount < ActiveRecord::Base
  belongs_to :user

  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  
end
