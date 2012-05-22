# -*- encoding : utf-8 -*-

class Provider
  Twitter="twitter"
  Facebook="facebook"
  LinkedIn="linked_in"


  def self.get(channel)
    providers = self.constants.collect do |constant|
      return constant if const_get(constant) == channel
    end
    providers.uniq!
    providers.delete nil
    providers.first unless providers.empty?
  end

   def self.from_channel(channel)
    channel = Channel.get channel
    self.const_get channel
  end

end

class Channel
  Twitter="tw"
  Facebook="fb"
  Default="tp"
  Email="em"
  LinkedIn="in"
  Widget="wg"

  def self.all
    constants.collect do |channel|
      const_get(channel)
    end
  end

  def self.get(channel)
    titles = self.constants.collect do |constant|
      return constant if const_get(constant) == channel
    end
    titles.uniq!
    titles.delete nil
    titles.first unless titles.empty?
  end


  def self.find(channel)
    return self.const_get(channel) if self.constants.include?(channel)
  end

  def self.from_provider(provider)
    provider = Provider.get provider
    self.const_get provider
  end

end

class RevenueParams
  Min_Payment= -1
end

class CampaignStatus
  Incomplete= "Incomplete"
  WaitingApproval = "Waiting approval"
  WaitingForPay= "Waiting for pay"
  NotApproved= "Not approved"
  Inactive= "Inactive"
  Expired= "Expired"
  NotBeginYet= "Not begin yet"
  OutOfMoney= "Out of money"
  Active="Active"
  Error="Error"
end

class CampaignMode
  PayPerLead = "Pay per Lead"
  PayPerClick = "Pay per Click"
  PayPerHit = "Pay per Hit"

end

class PostStatus
  Error="post_status.error"
  Posted="post_status.posted"
  Waiting="post_status.waiting"
end

class AnalyticsData
  Dimensions = ['landingPagePath', 'source' , 'city' ,'date']
  Metrics = ['visits'  , 'pageviews' , 'uniquePageviews']
end

class Commission
  LandingPageHit = 30.00
  ClientPageHit = 50.00
end

class Categories
  Categories = ['Alimentos','Arte','Autos','Bebes & Niños','Belleza','Bebidas','Blogs','Celebridades','Deals','Deportes','Educacion','Electronica & Gadgets','Empresas','Entretenimento','Familia','Finanzas','Hogar','Jovenes & Teen','Juegos','Libros','Marketing','Musica','Politica','Salud','Viajes']
end

class PaymentRequestStatus
  Created="payment_request_status.created"
  InProcess="payment_request_status.in_process"
  Paid="payment_request_status.paid"
  Rejected="payment_request_status.rejected"
  Observed="payment_request_status.observed"
  Commented="payment_request_status.observed"
  WaitingForUser="payment_request_status.waiting_user"

  def self.all
    self.constants
  end

  def self.get(status)
    return self.const_get(status) if self.constants.include?(status)
  end

end

class ImageSource
  Logo="image_source.logo"
  URL="image_source.url"
  File="image_source.file"

  def self.all
    self.constants
  end

  def self.get(status)
    return self.const_get(status) if self.constants.include?(status)
  end

end

