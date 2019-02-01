# - - - - - - - - - - - - - - -
# CORE DEPENDENCIES
# - - - - - - - - - - - - - - -

require 'rspec'
require 'rspec/expectations'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'pry'
require 'selenium-webdriver'
# require 'site_prism'
require 'webdriver-highlighter'
require 'rest-client'

# - - - - - - - - - - - - - - -
# CAPYBARA's MAGIC
# - - - - - - - - - - - - - - -
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1600,1050")
  options.add_argument("--disable-infobars")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, listener: WebDriverHighlighter.new)
end

# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :firefox)
# end

# Capybara.register_driver :selenium_firefox do |app|
#   options = Selenium::WebDriver::Firefox::Options.new
#   options.add_argument("--window-size=1600,1050")
#   options.add_argument("--disable-infobars")
#
#   Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, listener: WebDriverHighlighter.new)
# end

#Capybara.run_server = false
#Capybara.default_driver = :selenium_chrome
Capybara.default_driver = :selenium_chrome
Capybara.default_selector = :css
#Capybara.default_max_wait_time = 10
Capybara.ignore_hidden_elements = false
Capybara.app_host = 'https://loyalty-stage.500friends.com'


# - - - - - - - - - - - - - - -
# RSPEC SETTINGS
# - - - - - - - - - - - - - - -
RSpec.configure do |config|
  config.include Capybara::DSL

  config.before :all do
  end
  config.after :all do
  end

  config.filter_run debug: true
  config.run_all_when_everything_filtered = true

  config.color = true
  config.tty = true
  config.formatter = :documentation
end

