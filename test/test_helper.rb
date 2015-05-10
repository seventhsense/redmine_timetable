# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
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
