ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require "minitest/autorun"
require "minitest/rails"
require "minitest/pride"

class MiniTest::Rails::ActiveSupport::TestCase
  #include ActiveSupport::Testing::SetupAndTeardown
  #include ActionController::TestCase::Behavior
end
