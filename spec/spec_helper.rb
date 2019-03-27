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
require 'webdriver-highlighter'
require 'rest-client'
require 'gmail'

require './lib/requires'
require './lib/config/driver_settings'
require './lib/data/get_data'

$driver = Common::DriverSettings.new(
    environment:   ENV["ENVIRONMENT"],
    browser:       ENV["BROWSER"]
)

Dir['./lib/helpers/*.rb'].each { |f| require f }             # helpers
Dir['./spec/features/pages/**/*.rb'].each { |f| require f }  # page objects


Capybara.current_session.driver.browser.manage.window.maximize

# - - - - - - - - - - - - - - -
# RSPEC SETTINGS
# - - - - - - - - - - - - - - -
RSpec.configure do |config|
  # config.include Capybara::DSL

  # config.before :all do
  # end
  # config.after :all do
  # end

  # config.filter_run debug: true
  # config.run_all_when_everything_filtered = true

  config.color = true
  config.tty = true
  config.formatter = :documentation
end