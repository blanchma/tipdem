# -*- encoding : utf-8 -*-
#BitLy
require 'bitly'
Bitly.use_api_version_3
BITLY = Bitly.new(APP_CONFIG['bitly_username'], APP_CONFIG['bitly_key'])
