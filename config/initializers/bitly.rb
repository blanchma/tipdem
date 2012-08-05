# -*- encoding : utf-8 -*-
#BitLy
require 'bitly'
Bitly.use_api_version_3
BITLY = Bitly.new(Settings.bitly_username, Settings.bitly_key)
