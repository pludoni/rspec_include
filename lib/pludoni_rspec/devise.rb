RSpec.configure do |config|
  include Warden::Test::Helpers
  Warden.test_mode!
  config.include Devise::Test::ControllerHelpers, type: :controller
end
