# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :user
end

# == Schema Information
#
# Table name: payments
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  campaign_id     :integer(4)
#  money           :decimal(8, 2)   default(0.0)
#  paid_at         :datetime
#  additional_data :text
#  created_at      :datetime
#  updated_at      :datetime
#

