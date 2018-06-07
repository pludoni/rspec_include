if defined?(ActiveJob)
  RSpec.shared_context "active_job_inline" do
    include ActiveJob::TestHelper
    around(:each) do |ex|
      perform_enqueued_jobs do
        ex.run
      end
    end
  end
end

if defined?(ActionMailer::Base)
  RSpec.shared_context "mails" do
    def mails_with(to: nil)
      ActionMailer::Base.deliveries.select { |i| i.to.to_s[to] }
    end

    def last_mail
      ActionMailer::Base.deliveries.last
    end

    def mails
      ActionMailer::Base.deliveries
    end

    def extract_link_from(mail, link: 0)
      link = Nokogiri.parse(mail.html_part.decoded.to_s).search('a')[link]['href']
      URI.parse(link).tap { |i| i.host = nil; i.scheme = nil }.to_s
    end
  end
end
