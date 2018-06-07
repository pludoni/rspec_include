require 'capybara'
require 'chromedriver/helper'
require 'selenium-webdriver'
require 'headless'
require "selenium/webdriver"

module SystemTestChromeHelper
  def console_logs
    page.driver.browser.manage.logs.get(:browser)
  end

  def drop_in_dropzone(file_path)
    # Generate a fake input selector
    page.execute_script <<-JS
    fakeFileInput = window.$('<input/>').attr(
      {id: 'fakeFileInput', type:'file'}
    ).appendTo('body');
    JS
    # Attach the file to the fake input selector
    attach_file("fakeFileInput", file_path)
    # Add the file to a fileList array
    page.execute_script("var fileList = [fakeFileInput.get(0).files[0]]")
    # Trigger the fake drop event
    page.execute_script <<-JS
    var e = jQuery.Event('drop', { dataTransfer : { files : [fakeFileInput.get(0).files[0]] } });
    $('.uploader-action')[0].dropzone.listeners[0].events.drop(e);
    JS
  end

  def screenshot(path = '1')
    page.save_screenshot(Rails.root.join("public/screenshots/#{1.png}.png"))
  end

  # skip any confirm: "Really delete?"
  def skip_confirm(page)
    page.evaluate_script('window.confirm = function() { return true; }')
  end

  def in_browser(name)
    old_session = Capybara.session_name
    Capybara.session_name = name
    yield
    Capybara.session_name = old_session
  end
end


Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, timeout: 300)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      args: %w(headless disable-gpu window-size=1600,1200 no-sandbox)
    }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

RSpec.configure do |c|
  c.around(:all, js: true) do |ex|
    begin
      @headless = Headless.new
      @headless.start
      ex.run
    ensure
      @headless.destroy
    end
  end
end

Capybara.javascript_driver = :headless_chrome

RSpec.configure do |config|
  config.include SystemTestChromeHelper, type: :feature
  config.include SystemTestChromeHelper, type: :system
end
