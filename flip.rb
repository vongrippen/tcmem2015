require 'artoo'

connection :ardrone, :adaptor => :ardrone
device :drone, :driver => :ardrone, :connection => :ardrone

connection :navigation, :adaptor => :ardrone_navigation, :port => '192.168.1.1:5554'
device :nav, :driver => :ardrone_navigation, :connection => :navigation

work do
  on drone, :ready => :fly
  drone.start(nav)
end

def fly(*data)
  drone.take_off
  # binding.pry
  after(5.seconds) { drone.up(0.5) }
  after(10.seconds) { drone.animate(:wave, 5000) }
  after(10.seconds) { drone.animate(:flip_ahead, 5000) }
  after(15.seconds) { drone.hover.land }
  after(20.seconds) { drone.stop }
end
