begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'
require 'tmpdir'

#PTravel Settings
ENV['USER']="Pepazo"
ENV['PSW']="ILoveQA"

Capybara.default_driver = :selenium

# Set the host the Capybara tests should be run against
Capybara.app_host = ENV["CAPYBARA_HOST"]

# Set the time (in seconds) Capybara should wait for elements to appear on the page
Capybara.default_max_wait_time = 15
Capybara.default_driver = :selenium
Capybara.app_host = "https://cba.ucb.edu.bo/"

class CapybaraDriverRegistrar
  # register a Selenium driver for the given browser to run on the localhost
  # def self.register_selenium_driver(browser)
  #   Capybara.register_driver :selenium do |app|
  #     Capybara::Selenium::Driver.new(app, :browser => browser)
  #   end
  # end

  def self.register_selenium_driver(browser)
    Capybara.register_driver :selenium do |app|
      if browser == :chrome
        options = Selenium::WebDriver::Chrome::Options.new

        options.binary = 'C:/Program Files/Google/Chrome/Application/chrome.exe'

        options.add_argument("--user-data-dir=#{Dir.mktmpdir}")
        options.add_argument('--incognito')
        options.add_argument('--disable-save-password-bubble')
        options.add_argument('--disable-password-generation')
        options.add_argument('--disable-notifications')
        options.add_argument('--disable-popup-blocking')
        options.add_argument('--password-store=basic')
        options.add_argument('--disable-features=PasswordManagerOnboarding,PasswordCheck,LeakDetectionUnauthenticated,AutofillServerCommunication')

        prefs = {
          'credentials_enable_service' => false,
          'profile.password_manager_enabled' => false,
          'profile.password_manager_leak_detection' => false,
          'profile.default_content_setting_values.notifications' => 2,
          'autofill.profile_enabled' => false,
          'autofill.credit_card_enabled' => false
        }

        options.add_preference(:prefs, prefs)

        Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
      else
        Capybara::Selenium::Driver.new(app, browser: browser)
      end
    end
  end

end
# Register various Selenium drivers
#CapybaraDriverRegistrar.register_selenium_driver(:internet_explorer)
#CapybaraDriverRegistrar.register_selenium_driver(:firefox)
CapybaraDriverRegistrar.register_selenium_driver(:chrome)
Capybara.run_server = false
#World(Capybara)

Dir[File.join(__dir__, '../pages/*.rb')].sort.each { |file| require file }