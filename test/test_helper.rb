# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
module Redmine
  module PluginFixturesLoader
    def self.included(base)
      base.class_eval do
        def self.plugin_fixtures(*symbols)
          ActiveRecord::FixtureSet.create_fixtures(File.dirname(__FILE__) + '/fixtures/', symbols)
        end
      end
    end
  end
end

unless ActionController::TestCase.included_modules.include?(Redmine::PluginFixturesLoader)
  ActionController::TestCase.send :include, Redmine::PluginFixturesLoader
end
# require 'simplecov'
require 'minitest/hell'
require 'minitest/reporters'
# require 'database_cleaner'
# Minitest::Reporters.use!
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# DatabaseCleaner.strategy = :truncation
# DatabaseCleaner.clean

include MiniTest::ActiveRecordAssertions
# SimpleCov.start do
  # root(SimpleCov.root + '/plugins/redmine_timetable')
  # add_group "Models", "plugins/redmine_timetable/app/models"
  # coverage_dir(SimpleCov.root + '/coverage')
# end

