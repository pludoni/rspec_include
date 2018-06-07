require "pludoni_rspec/version"

# rubocop:disable Rails/FilePath
module PludoniRspec
  def self.run
    ENV["RAILS_ENV"] ||= 'test'
    coverage!
    require 'pry'
    require File.expand_path("config/environment", Dir.pwd)
    require 'rspec/rails'

    require 'pludoni_rspec/spec_helper'
    require 'pludoni_rspec/capybara'
    require 'pludoni_rspec/freeze_time'
    if defined?(VCR)
      require 'pludoni_rspec/vcr'
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
