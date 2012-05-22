# -*- encoding : utf-8 -*-
require 'rubygems'
require 'mongo'

class MongoDB
  
  def initialize(session=nil)
    #@conn = Mongo::Connection.new(APP_CONFIG['domain'],27017)
    @conn = Mongo::Connection.new
    puts "APPPPPPPPP" , APP_VARS['mongo']['mongo_db']
    @db   = @conn[APP_VARS['mongo']['mongo_db']]
    @coll = @db[APP_VARS['mongo']['mongo_collection']]
    #@coll.remove
  end

  def upsert(line)
    params = line.split(',')
    @coll.update({"landingPagePath" => params[0] , "source" => params[1] , "city" => params[2] , "date" => params[3] },    	{"$set" => {"visits" => params[4]  , "pageviews" => params[5] , "uniquePageviews" => params[6] , "entranceRate" =>  	params[7]}} , :upsert => true)
    
  end

  def get_campaign(campaign_uri)
    ret = []
    @coll.find("landingPagePath" => campaign_uri).each { |row| ret << row }
    ret
  end

end
