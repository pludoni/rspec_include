require "pludoni_rspec/version"

# rubocop:disable Rails/FilePath
module PludoniRspec
  class Config
    class << self
      attr_accessor :chrome_driver_version
      attr_accessor :destroy_headless
      attr_accessor :wrap_js_spec_in_headless
      attr_accessor :chrome_arguments
      attr_accessor :capybara_timeout
      attr_accessor :capybara_driver
      attr_accessor :firefox_arguments
    end
    self.chrome_driver_version = "2.36"
    self.destroy_headless = true
    self.wrap_js_spec_in_headless = RbConfig::CONFIG['host_os']['linux']
    self.chrome_arguments = ['headless', 'disable-gpu', "window-size=1600,1200", 'no-sandbox', 'disable-dev-shm-usage', 'lang=de']
    self.capybara_timeout = ENV['CI'] == '1' ? 30 : 5
    self.firefox_arguments = ['--headless', '--window-size=1600,1200']
    self.capybara_driver = :headless_chrome
  end
  def self.run
    ENV["RAILS_ENV"] ||= 'test'
    coverage!
    require 'pry'
    require File.expand_path("config/environment", Dir.pwd)
    abort("The Rails environment is running in production mode!") if Rails.env.production?
    require 'rspec/rails'

    require 'pludoni_rspec/spec_helper'
    require 'pludoni_rspec/capybara'
    require 'pludoni_rspec/freeze_time'
    require 'pludoni_rspec/shared_context'
    if defined?(VCR)
      require 'pludoni_rspec/vcr'
    end
    if defined?(Devise)
      require 'pludoni_rspec/devise'
    end
    Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
    ActiveRecord::Migration.maintain_test_schema!
  end

  def self.coverage!
    require 'simplecov'
    SimpleCov.start 'rails' do
      add_filter do |source_file|
        source_file.lines.count < 10
      end
      add_group "Long files" do |src_file|
        src_file.lines.count > 150
      end
    end
  end
end
