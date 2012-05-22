# -*- encoding : utf-8 -*-
require 'rubygems'
require 'gattica'
require 'hpricot'
#require 'mongo'

class Analytics

  def initialize(session=nil)
    @ga = Gattica.new({
        :email => 'gauchosolitarioar@gmail.com',
        :password => 'gauchogaucho',
        :timeout => 500 })
    @ga.profile_id = 45560823
  end

  def get_data(time)
    puts "processing analytics for " , time
    year = time.year.to_s

    month = time.month.to_s
    if month.size == 1
      month = '0'+month
    end

    day = time.day.to_s
    if day.size == 1
      day = '0'+day
    end

    start_date = year+'-'+month+'-'+day

    results = @ga.get({ :start_date => start_date,
        :end_date => start_date,
        :dimensions => AnalyticsData::Dimensions ,
        :metrics => AnalyticsData::Metrics})

    results.points.each do |item|

      stats = Statistic.new
      puts item
      item.dimensions.each do |dimension|
         AnalyticsData::Dimensions.each do |const|
           if dimension.to_s.include? const
             result = dimension.to_s.split(const)
             stats.write_attribute("#{const.strip}" ,result[1])
           end
         end
      end

      item.metrics.each do |metric|
         AnalyticsData::Metrics.each do |const|
           if metric.to_s.include? const
             result = metric.to_s.split(const)
             stats.write_attribute("#{const.strip}" ,result[1])
           end
         end
      end

    stats.save

    end
  end
end
