require "capybara"
require "headless"
require "puma"
require 'pludoni_rspec/system_test_chrome_helper'

require 'capybara/apparition'
Capybara.register_driver :apparition_debug do |app|
  Capybara::Apparition::Driver.new(app, js_errors: true, browser_options: { 'no-sandbox' => true })
end
Capybara.register_driver :apparition do |app|
  if ENV['CI']
    options[:browser_options] = { 'no-sandbox' => true }
  end
  Capybara::Apparition::Driver.new(app, PludoniRspec::Config.apparition_arguments)
end
Capybara.javascript_driver = :apparition

RSpec.configure do |c|
  c.include PludoniRspec::SystemTestChromeHelper, type: :feature
  c.include PludoniRspec::SystemTestChromeHelper, type: :system
  c.before(:all, js: true) do
    # disable puma output
    Capybara.server = :puma, { Silent: true }
  end
  c.before(:each, type: :system) do
    if defined?(driven_by)
      driven_by :apparition
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
