RSpec.configure do |config|
  config.example_status_persistence_file_path = 'tmp/rspec.failed.txt'
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/
  config.before do
    I18n.locale = I18n.default_locale
    if defined?(Fabrication)
      Fabrication::Sequencer.reset
    end
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :defined
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  if defined?(ActionMailer::Base)
    config.before(:each) do
      ActionMailer::Base.deliveries.clear
    end
  end
  config.filter_rails_from_backtrace!
  config.filter_gems_from_backtrace("fabrication")
  config.filter_gems_from_backtrace("grape")
  config.filter_gems_from_backtrace("rack")

  config.around(:each, :timeout) do |example|
    time = 10 unless time.kind_of?(Numeric)
    Timeout.timeout(time) do
      example.run
    end
  end
end
