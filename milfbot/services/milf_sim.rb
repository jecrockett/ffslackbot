require 'tzinfo'

class MilfSim
  def self.simulate_MILF
    #Run python code
  end
end

offset = TZInfo::Timezone.get("America/New_York").current_period.offset.utc_total_offset/3600
hour = 12-offset

simulation = Rufus::Scheduler.new

simulation.cron "36 #{hour} * * fri" do
  print 'Simulating the rest of the season...'
  MilfSim.simulate_MILF
  puts 'done!'
end
