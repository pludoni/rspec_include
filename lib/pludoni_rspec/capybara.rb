require "capybara"
require "selenium-webdriver"
require "headless"
require "puma"
require 'pludoni_rspec/system_test_chrome_helper'
require 'webdrivers/geckodriver'

RSpec.configure do |c|
  c.before(:all, js: true) do
    Webdrivers.cache_time = 86_400
    Webdrivers::Geckodriver.update
  end
  c.include PludoniRspec::SystemTestChromeHelper, type: :feature
  c.include PludoniRspec::SystemTestChromeHelper, type: :system
  c.before(:all, js: true) do
    # disable puma output
    Capybara.server = :puma, { Silent: true }
  end
  c.before(:each, js: true) do
    if defined?(driven_by)
      driven_by :selenium_headless, using: :firefox, screen_size: [1400, 1400]
    end
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
