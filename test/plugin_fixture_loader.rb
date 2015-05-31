module Redmine
  # enable method plugin_fixture
  module PluginFixturesLoader
    def self.included(base)
      base.class_eval do
        def self.plugin_fixtures(*symbols)
          ActiveRecord::FixtureSet.create_fixtures(
            File.dirname(__FILE__) + '/fixtures/', symbols
          )
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
