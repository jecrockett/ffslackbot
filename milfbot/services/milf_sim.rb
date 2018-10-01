class MilfSim
  def self.simulate_MILF
    #Run python code
  end
end

simulation = Rufus::Scheduler.new
simulation.cron "0 13 * * thu" do
  print 'Simulating the rest of the season...'
  MilfSim.simulate_MILF
  puts 'done!'
end
