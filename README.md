# PludoniRspec

pludoni GmbH's RSpec helper for modern Rails apps (+5.1, RSpec > 3.5)

Just include in your spec_helper / rails_helper

```ruby
ENV["RAILS_ENV"] ||= 'test'

require 'pludoni_rspec'
PludoniRspec.run
load 'spec/fabricators.rb'
```

What's done:

* Maintain Test Schema
* spec/support/**.rb will be loaded for overriding
* freeze_time: '' Tag for examples. If Timecop is available, this will be used, otherwise Rails 5.x default travel_to
* Simplecov coverage started at beginning
* Capybara+Chromedriver config with Chromedriver, Headless (will probably not work on OSX though)
  *  Available Helper:
    * console_logs
    * drop_in_dropzone(file_path)
    * screenshot
    * skip_confirm(page)
    * in_browser('user_1') do ... end

* Rspec configs:
  * tmp/rspec.failed.txt to enable --next-failure / --only-failures switches
  * clears ActionMailer deliveries before each scenario
  * default backtrace without rails, fabication, grape, rack
  * fixtures in spec/fixtures
  * Transactional Fixtures enabled - no DatabaseCleaner needed anymore
* VCR Config sensible VCR is available (not required by Gem)
* executable: nf and of
  * nf -> rspec --next-failure
  * of -> rspec --only-failures

