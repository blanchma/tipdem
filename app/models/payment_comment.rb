# -*- encoding : utf-8 -*-
class PaymentComment < ActiveRecord::Base

  belongs_to :payment_request
end

# == Schema Information
#
# Table name: payment_comments
#
#  id                 :integer(4)      not null, primary key
#  user_name          :string(255)
#  title              :string(255)
#  payment_request_id :integer(4)
#  internal           :boolean(1)
#  message            :text
#  type_message       :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

