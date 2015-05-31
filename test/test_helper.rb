# setting coveralls
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter do |source_file|
    # only plugin directory
    !source_file.filename.include?('plugins/redmine_timetable') || !source_file.filename.end_with?('.rb')
  end
end

# load redmine test_helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
# multithreading
require 'minitest/hell'
# method plugin_fixtures
require File.expand_path(File.dirname(__FILE__) + '/plugin_fixture_loader')
# setting minitest_reporters
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# include MiniTest::ActiveRecordAssertions
include MiniTest::ActiveRecordAssertions
