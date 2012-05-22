# -*- encoding : utf-8 -*-
class Authentication < ActiveRecord::Base
  belongs_to :user
  before_create :define_type

  def generate_token!
    self.verify_token = ActiveSupport::SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz') 
  end

  def define_type
    if provider == "facebook"
      write_attribute(:type, "FacebookAccount")
    elsif provider == "twitter"
      write_attribute(:type, "TwitterAccount")
    elsif provider == "linked_in"
      write_attribute(:type, "LinkedInAccount")
    else
      write_attribute(:type, nil)
    end
  end


  def channel
    channel = case self.provider
    when "twitter" then Channel::Twitter
    when "facebook" then Channel::Facebook
    when "linked_in" then Channel::LinkedIn
    end
    channel
  end
  

end
