class Reward < ActiveRecord::Base
  attr_accessible :special, :product, :campaign

  belongs_to :product
  belongs_to :campaign
end
