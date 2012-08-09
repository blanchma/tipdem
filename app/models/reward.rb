class Reward < ActiveRecord::Base
  attr_accessible :special, :product, :campaign

  belongs_to :product
  belongs_to :campaign

  before_create :set_stock

  def set_stock
    self.current_stock = initial_stock
  end

end
