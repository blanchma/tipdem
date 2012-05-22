# -*- encoding : utf-8 -*-
require 'warden'

Spec::Runner.configure do |config|
  config.include Warden::Test::Helpers, :type => :acceptance
  config.after(:each, :type => :acceptance) { Warden.test_reset! }
end
