# -*- encoding : utf-8 -*-
require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.

end




ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

require 'database_cleaner'
require 'capybara/rails'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction
# then make the DatabaseCleaner.start and DatabaseCleaner.clean calls appropriately

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}


Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = Rails.root + '/spec/fixtures/'

   config.include Capybara::DSL, :type => :views
   config.include Devise::TestHelpers, :type => :controller
   #config.extend DeviseMacros, :type => :controller



  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

