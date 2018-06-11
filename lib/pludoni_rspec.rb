require "pludoni_rspec/version"

# rubocop:disable Rails/FilePath
module PludoniRspec
  class Config
    class << self
      attr_accessor :chrome_driver_version
      attr_accessor :chrome_window_size
    end
    self.chrome_driver_version = "2.36"
    self.chrome_window_size = '1600,1200'
  end
  def self.run
    ENV["RAILS_ENV"] ||= 'test'
    coverage!
    require 'pry'
    require File.expand_path("config/environment", Dir.pwd)
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
