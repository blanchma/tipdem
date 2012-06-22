# -*- encoding : utf-8 -*-
class Statistic < ActiveRecord::Base

end

# == Schema Information
#
# Table name: statistics
#
#  id              :integer(4)      not null, primary key
#  landingPagePath :string(255)
#  source          :string(255)
#  city            :string(255)
#  date            :datetime
#  visits          :integer(4)
#  pageviews       :integer(4)
#  uniquepageviews :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

