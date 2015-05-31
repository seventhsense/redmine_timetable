require File.expand_path(File.dirname(__FILE__) + '/../../../../test/ui/base')
require 'capybara/poltergeist'

class  LoginTest < Redmine::UiTest::Base
  # plugin_fixtures :users
  fixtures :projects, :versions, :users, :email_addresses, :roles, :members,
           :member_roles, :issues, :journals, :journal_details,
           :trackers, :projects_trackers, :issue_statuses,
           :enabled_modules, :enumerations, :boards, :messages,
           :attachments, :custom_fields, :custom_values, :time_entries,
           :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions
          
  def setup
    # Capybara.current_driver = Capybara.javascript_driver 
    # Capybara.run_server = true
    # Capybara.server_port = 3001
    Capybara.default_driver = :poltergeist
    # Capybara.app_host = 'http://127.0.0.1:3001/'
    # @driver = Selenium::WebDriver.for :firefox
    # host = Capybara.current_session.server.host
    # port = Capybara.current_session.server.port
    # @base_url = "#{host}:#{port}"
    # p @base_url
    # @accept_next_alert = true
    # @driver.manage.timeouts.implicit_wait = 10
    # @verification_errors = []
    # Capybara.use_default_driver 
  end
  
  def teardown
    # Capybara.use_default_driver 
    # @driver.quit
    # assert_equal [], @verification_errors
  end
  
  def test_login
    log_user('admin', 'admin')
    # get '/ttevents'
    visit ttevents_path
    # page.driver.debug
    # assert_response :success
    # assert_template 'ttevents/index'
    # binding.pry
    # @driver.get(@base_url + "/")
    # @driver.find_element(:link, "ログイン").click
    # @driver.find_element(:id, "username").clear
    # @driver.find_element(:id, "username").send_keys "admin"
    # @driver.find_element(:id, "password").clear
    # @driver.find_element(:id, "password").send_keys "admin"
    # @driver.find_element(:name, "login").click
    # @driver.find_element(:link, "時間表").click
    # verify { assert_equal "時間表", @driver.find_element(:css, "h2").text }
    # @driver.find_element(:link, "ログアウト").click
  end

  def element_present?(how, what)
    @receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @receiver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @receiver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
