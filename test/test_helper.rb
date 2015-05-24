# Load the Redmine helper
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter do |source_file|
    # redmine プラグインの ruby ファイルだけ対象にする
    !source_file.filename.include?("plugins/redmine_timetable") || !source_file.filename.end_with?(".rb")
  end
end

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
unless Redmine::IntegrationTest.included_modules.include?(Redmine::PluginFixturesLoader)
  Redmine::IntegrationTest.send :include, Redmine::PluginFixturesLoader
end
require 'minitest/rails/capybara'
require 'minitest/hell'
require 'minitest/reporters'
require 'capybara/poltergeist'
require 'selenium-webdriver'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

include MiniTest::ActiveRecordAssertions
