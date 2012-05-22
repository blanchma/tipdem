# -*- encoding : utf-8 -*-
class PanelNotice < ActiveRecord::Base

  validates_length_of :message, :maximum => 100
end
