# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :user
end
