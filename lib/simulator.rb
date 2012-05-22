# -*- encoding : utf-8 -*-
class Simulator
 
  def initialize(fee,level,ctr_facebook, ctr_twitter,num_seed_facebook,num_seed_twitter,num_standart_facebook,num_standart_twitter)
    @ctr_facebook = ctr_facebook
    @ctr_twitter = ctr_twitter
    @fee = fee
    @num_seed_twitter = num_seed_twitter
    @num_seed_facebook = num_seed_facebook
    @num_standart_twitter = num_standart_twitter
    @num_standart_facebook = num_standart_facebook
    @level = level
    #puts "salida" , @fee , @level , @ctr_facebook , @ctr_twitter
  end

  def get_twitter
   forward_twitter(0)
  end

  def get_facebook
   forward_facebook(0)
  end

  def forward_twitter(level)
    if level < @level
      if level == 0
        selected_users = ((@num_seed_twitter * @ctr_twitter)/100.0)
        earning_twitter = selected_users * @fee
        selected_users.to_i.times.each {earning_twitter +=forward_twitter(level+1)}
      elsif level > 0
        selected_users = ((@num_standart_twitter * @ctr_twitter)/100.0)
        earning_twitter = selected_users * @fee
        selected_users.to_i.times.each {earning_twitter +=forward_twitter(level+1)}
      end
      earning_twitter
    else
      0
    end 
  end
  
  def forward_facebook(level)
    if level < @level
      if level == 0
        selected_users = ((@num_seed_facebook * @ctr_facebook)/100.0)
        earning_facebook = selected_users * @fee
        selected_users.to_i.times.each {earning_facebook +=forward_facebook(level+1)}
      elsif level > 0
        selected_users = ((@num_standart_facebook * @ctr_facebook)/100.0)
        earning_facebook = selected_users * @fee
        selected_users.to_i.times.each {earning_facebook +=forward_facebook(level+1)}
      end
      earning_facebook
    else
      0
    end 
  end

end

#c = Calculator.new(1.0,4.0,0.25,1000,4000,100,10)
#c = Calculator.new(1.0,5.0,0.30,140.682,38.567,100,25)
#c.get


