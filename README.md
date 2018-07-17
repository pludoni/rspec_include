# PludoniRspec

[![Gem Version](https://badge.fury.io/rb/pludoni_rspec.svg)](https://badge.fury.io/rb/pludoni_rspec)

pludoni GmbH's RSpec helper for modern Rails apps (+5.1, RSpec > 3.5)

Just include in your spec_helper / rails_helper

```ruby
ENV["RAILS_ENV"] ||= 'test'

require 'pludoni_rspec'
PludoniRspec.run
```

What's done:

* Maintain Test Schema
* ``spec/support/**.rb`` will be loaded for overriding in projects
* ``describe 'what', freeze_time: '2018-01-01 12:00' do`` Tag for examples. If Timecop is available, this will be used, otherwise Rails 5.x default travel_to
* Simplecov coverage recording started at beginning
* Capybara+Chromedriver config with Chromedriver, Headless (will probably not work on OSX though)
  *  Available Helper:
    * ``console_logs`` - Show console log output of browser
    * ``drop_in_dropzone(file_path)`` - drop a file into the first "Dropzone"
    * ``screenshot(path=nil)`` - make a screenshot to public/screenshots/*.png
    * ``skip_confirm(page)`` - ignore all confirm('') alert boxes from now
    * ``in_browser('user_1') do ... end`` - simulate multi-user scenarios / change browser session

* Rspec configs:
  * Persistence Path: ``tmp/rspec.failed.txt`` to enable --next-failure / --only-failures switches
  * executable: ``nf`` and ``of``
    * nf -> rspec --next-failure
    * of -> rspec --only-failures
  * clears ActionMailer deliveries before each scenario
  * default backtrace without rails, fabrication, grape, rack
  * fixtures in spec/fixtures
  * Transactional Fixtures enabled - no DatabaseCleaner needed anymore for Rails > 5.1

Optional - Loaded if companion gem is available:

* VCR - sensible VCR is available (not required by Gem)
* Devise - Test helpers loaded, if Devise is available, and included in Controller specs

* Shared Contexts that can be included on demand:
  * ``include_context 'mails'`` - For working with ActionMailer::Base.deliveries
    * mails_with(to: '')  - Filter mails sent to a user
    * last_mail  == ActionMailer::Base.deliveries.last
    * mails  == ActionMailer::Base.deliveries
    * extract_link_from(last_mail, link: 0)  - gets you the link (without protocol + host) of the first link in the last mail with a html body
  * ``include_context 'active_job_inline'``
    * all ActiveJobs will be run immediately in this group
