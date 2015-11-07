require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

connection :navigation, :adaptor => :ardrone_navigation, :port => '192.168.1.1:5554'
device :nav, :driver => :ardrone_navigation, :connection => :navigation

connection :videodrone, :adaptor => :ardrone_video, :port => '192.168.1.1:5555'
device :video, :driver => :ardrone_video, :connection => :videodrone

work do
  # on nav, :update => :nav_update
  on video, :frame => :v_frame

  on nav, :navdata => proc { |caller, navdata| puts "Sequence number: #{ navdata.sequence_number }" }
  on nav, :demo => proc { |caller, navdata, nav_option_demo|
    puts "Ardrone pitch: #{ nav_option_demo.pitch }"
    puts "Ardrone roll:  #{ nav_option_demo.roll }"
    puts "Ardrone yaw:   #{ nav_option_demo.yaw }"
  }

  drone.start
  drone.take_off

  after(25.seconds) { drone.hover.land }
  after(30.seconds) { drone.stop }
end

def v_frame(*data)
  @count ||= 0
  @count += 1
  puts "Frame# #{@count} #{data[1].size} bytes"
end

def nav_update(*data)
  data[1].drone_state.each do |name, val|
    p "#{name}: #{val}"
  end
end
