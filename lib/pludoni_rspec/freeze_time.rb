RSpec.configure do |c|
  if defined?(Timecop)
    c.around(:each, :freeze_time) do |example|
      time = example.metadata[:freeze_time]
      begin
        Timecop.freeze(Time.zone.parse(time)) do
          example.run
        end
      ensure
        Timecop.return
      end
    end

  else

    c.include ActiveSupport::Testing::TimeHelpers
    c.around(:each, :freeze_time) { |example|
      time = Time.zone.parse(example.metadata[:freeze_time])
      travel_to time
      begin
        example.run
      ensure
        travel_back
      end
    }
  end
end
