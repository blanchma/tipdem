# -*- encoding : utf-8 -*-
class GoogleChart

    def self.annotated_time_line(campaign_id)
      date = Array.new
      response_text=""
      data_landing_hits = LandingPageHit.get_data_for_graph(campaign_id)
      data_client_hits = ClientPageHit.get_data_for_graph(campaign_id)
      
      data_landing_hits.each_key do |key|
        date << key
      end
    
      data_client_hits.each_key do |key|
        date << key if not data_landing_hits.has_key?(key)
      end

      date.each do |d|
        click = data_landing_hits.has_key?(d)  ? data_landing_hits[d] : 0
        hit = data_client_hits.has_key?(d)  ? data_client_hits[d] : 0
        h = parse_date(d)
        response_text+= "[new Date(#{h['year']},#{h['month']},#{h['day']}),#{click},undefined,undefined,#{hit},undefined,undefined],"
      end
    response_text[0..-2]
    end

   #imagePieChartGender
  def self.image_pie_chart_gender(campaign_id)
    gender_data = Hash.new
    gender_data['male'] = 0
    gender_data['female'] = 0
    u_list = (Campaign.find_by_id campaign_id).promotors
    
    u_list.each do |user|
      gender = user.gender 
      if gender == 'male'
        gender_data['male'] += 1
      elsif gender == 'female'
        gender_data['female'] += 1
      end  
    end
    return gender_data
  end
  
  def self.image_pie_chart_click_referer(campaign_id)
    referer = Hash.new
    referer['facebook'] = LandingPageHit.facebook.all(:conditions => {:campaign_id => campaign_id}).count
    referer['twitter'] = LandingPageHit.twitter.all(:conditions => {:campaign_id => campaign_id}).count
    referer['tipdem'] = LandingPageHit.default.all(:conditions => {:campaign_id => campaign_id}).count
    return referer
  end  

  def self.image_pie_chart_hit_referer(campaign_id)
    referer = Hash.new
    referer['facebook'] = LandingPageHit.facebook.all(:conditions => {:campaign_id => campaign_id}).count
    referer['twitter'] = LandingPageHit.twitter.all(:conditions => {:campaign_id => campaign_id}).count
    referer['tipdem'] = LandingPageHit.default.all(:conditions => {:campaign_id => campaign_id}).count
    return referer
  end 

  private
  
  def self.parse_date(date)
    parsed_date = Hash.new
    splited_date = date.split('-')
    parsed_date['year'] = splited_date[0]
    parsed_date['month'] = (splited_date[1].size > 1 and splited_date[1].chars.first == '0') ? splited_date[1][1..-1] : splited_date[1]
    parsed_date['day'] = (splited_date[2].size > 1 and splited_date[2].chars.first == '0') ? splited_date[2][1..-1] : splited_date[2]
    return parsed_date
  end

end
