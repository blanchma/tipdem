# -*- encoding : utf-8 -*-
class PanelNotice < ActiveRecord::Base

  validates_length_of :message, :maximum => 100
end

# == Schema Information
#
# Table name: panel_notices
#
#  id         :integer(4)      not null, primary key
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

