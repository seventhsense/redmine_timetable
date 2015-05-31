# setting coveralls
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter do |source_file|
    # redmine プラグインの ruby ファイルだけ対象にする
    !source_file.filename.include?("plugins/redmine_timetable") || !source_file.filename.end_with?(".rb")
  end
end

# load redmine test_helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
# multithreading
require 'minitest/hell'
# method plugin_fixtures
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
# setting minitest_reporters
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# include MiniTest::ActiveRecordAssertions
include MiniTest::ActiveRecordAssertions
