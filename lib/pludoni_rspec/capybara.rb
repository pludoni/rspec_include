require "capybara"
require "chromedriver/helper"
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
      args: ['headless', 'disable-gpu', "window-size=#{PludoniRspec::Config.chrome_window_size}", 'no-sandbox']
    }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

RSpec.configure do |c|
  c.before(:all, js: true) do
    # disable puma output
    Capybara.server = :puma, { Silent: true }
  end
  c.around(:all, js: true) do |ex|
    begin
      if !@headless and RbConfig::CONFIG['host_os']['linux']
        @headless = Headless.new(destroy_at_exit: true, reuse: true)
        @headless.start
      end
      ex.run
    ensure
      if @headless and PludoniRspec::Config.destroy_headless
        puts "DESTROY HEADLESS"
        @headless.destroy
      end
    end
  end
end

Chromedriver.set_version(PludoniRspec::Config.chrome_driver_version)

Capybara.javascript_driver = :headless_chrome

RSpec.configure do |config|
  config.include PludoniRspec::SystemTestChromeHelper, type: :feature
  config.include PludoniRspec::SystemTestChromeHelper, type: :system
end
Capybara.default_max_wait_time = 60
