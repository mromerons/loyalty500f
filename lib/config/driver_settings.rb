require 'selenium-webdriver'
# require 'chromedriver/helper'
# require 'yaml'

module Common
  class DriverSettings

    attr_reader :environment, :browser

    def initialize(params={})
      @environment =    params[:environment]                || 'loyalty-stage'
      @browser =        params[:browser]                    || 'chrome'

      # Capybara default settings
      Capybara.default_driver = :selenium
      # Capybara.app_host = webhost_for(environment: @environment, app: @app)
      Capybara.app_host = "https://" + @environment + ".500friends.com"
      Capybara.run_server = false
      Capybara.default_max_wait_time = 10
      Capybara.default_selector = :css
      Capybara.ignore_hidden_elements = false

      start_driver
    end


    private

    def start_driver
      puts 'Running on environment: ' + @environment + ' with browser: ' + @browser
      Capybara.register_driver :selenium do |app|
        # driver # return value of register_driver block must be driver object
        driver = Capybara::Selenium::Driver.new(app, browser_settings.merge({listener: WebDriverHighlighter.new}))
        driver
      end
    end


    def browser_settings
      case @browser
        when 'chrome'
          chrome_settings
        when 'firefox'
          firefox_settings
        else
          raise ArgumentError.new('Invalid browser')
      end
    end

    def chrome_settings
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--window-size=1800,1050")
      options.add_argument("--disable-infobars")
      { browser: :chrome, options: options }
    end

    def firefox_settings
      { browser: :firefox }

      # profile = Selenium::WebDriver::Firefox::Profile.new
      # profile.native_events = true
      # options = Selenium::WebDriver::Firefox::Options.new
      # options.profile = profile
      # { browser: :firefox, options: options }
    end
  end
end
