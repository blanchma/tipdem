# -*- encoding : utf-8 -*-
class RevenueCommission < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :revenue


  
#  attr_accessor :source
  
#  validates_presence_of :source_class, :source_id
#
##  def source_model
##    eval(source_class) if source_class
#  end
#
#  def source=(source)
#    if source && source.id
#      self.source_class=source.class.to_s
#      self.source_id=source.id
#    end
#  end
#
#  def source
#    if source_class && source_id
#      source_model = eval(source_class)
#      return source_model.find source_id
#    end
#  end

 

end

# == Schema Information
#
# Table name: revenue_commissions
#
#  id           :integer(4)      not null, primary key
#  revenue_id   :integer(4)
#  campaign_id  :integer(4)
#  money        :decimal(8, 2)   default(0.0)
#  source_class :string(255)
#  source_id    :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

