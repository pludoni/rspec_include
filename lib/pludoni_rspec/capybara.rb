require "capybara"
require "selenium-webdriver"
require "headless"
require "selenium/webdriver"
require "puma"
require 'pludoni_rspec/system_test_chrome_helper'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, timeout: 300)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      args: PludoniRspec::Config.chrome_arguments
    }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.register_driver :headless_firefox do |app|
  options = ::Selenium::WebDriver::Firefox::Options.new
  options.args += PludoniRspec::Config.firefox_arguments
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

if PludoniRspec::Config.capybara_driver == :headless_chrome
  require "chromedriver/helper"
  Chromedriver.set_version(PludoniRspec::Config.chrome_driver_version)
  Capybara.javascript_driver = :headless_chrome
else
  require 'geckodriver/helper'
  Capybara.javascript_driver = :headless_firefox
end

RSpec.configure do |c|
  c.include PludoniRspec::SystemTestChromeHelper, type: :feature
  c.include PludoniRspec::SystemTestChromeHelper, type: :system
  c.before(:all, js: true) do
    # disable puma output
    Capybara.server = :puma, { Silent: true }
  end
  c.around(:all, js: true) do |ex|
    begin
      if !@headless and PludoniRspec::Config.wrap_js_spec_in_headless
        @headless = Headless.new(destroy_at_exit: true, reuse: true)
        @headless.start
      end
      ex.run
    ensure
      if @headless and PludoniRspec::Config.destroy_headless
        @headless.destroy
      end
    end
  end
end
Capybara.default_max_wait_time = PludoniRspec::Config.capybara_timeout
