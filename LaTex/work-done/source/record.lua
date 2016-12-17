-- record.lua
--
-- This script spawns new VLC instances when the sensor is triggered.
-- Config variables are in config.lua

require "config"
require "init"

-- Open sensor device 

-- Sleeptime for nanosleep
local tsp = {}
tsp['tv_nsec'] = 100000000 --100ms

-- Buffer for last video file
local lastvideo = nil

-- Timer for shutdown
local downtimer = 0
local isexpiring = false

-- VLC PID & pipes
vlc_pid = nil

-- Pin states for polling
sstate = nil
s = 0

-- Begin main loop
print("Started, entering main loop")
repeat

	-- Poll sensor & time
	sstate = s
	local sensor = io.open("/sys/class/gpio/gpio"..SensorInputPin.."/value")
	s = tonumber(sensor:read())
	sensor:close()
	local dDate = os.date("%Y-%m-%d")
	local dTime = os.date("%X")
	
	-- New entry
	if s == 1 and sstate ~= s then	
		
		-- If no record is in progress, start a new one
		if vlc_pid == nil then
			
			-- Define video filename
			lastvideo = (dDate.."-"..os.date("%H%M%S")..".mp4")

			-- Fork VLC process
			vlc_pid = unistd.fork()
			if vlc_pid == nil then lastvideo = "NULL" 	-- error
				print("ERROR: Unable to fork process")
			elseif vlc_pid == 0 then 			-- in child

				unistd.exec("/usr/bin/cvlc",{[0] = "-I rc",
					     "v4l2://",
					     ":v4l2-dev="..VideoDeviceMount,
					     ":v4l2-chroma="..VideoDeviceStream,
					     ":v4l2-width="..tostring(VideoCaptureWidth),
				     	     ":v4l2-height="..tostring(VideoCaptureHeight),
				     	     ":v4l2-fps="..tostring(VideoCaptureFramerate),
				     	     [[--sout=#std{access=file,mux=mp4,dst=]]..VideoOutputDir..lastvideo..[[}]],})

			end
			
		-- If one IS running, stop shutdown and extend current video file
		else
			isexpiring = false
		end

		-- DB entry
		local crs = conn:execute("INSERT INTO Records(RecordDateTime,VideoPath) VALUES('"..dDate.." "..dTime.."','"..tostring(lastvideo).."');")
		commit()
		
	-- Stop recording ...
	elseif s == 0 and sstate ~= s and vlc_pid ~= nil and isexpiring == false then
		
		-- Start countdown
		isexpiring = true
		downtimer = os.clock()
	end

	-- Timer
	if isexpiring == true then
		if (os.clock()-downtimer) >= RecordStopDelay*0.025 then
			
			-- Stop recording, quit VLC
			sig.kill(vlc_pid,sig.SIGINT)
			vlc_pid = nil
			lastvideo = nil
			isexpiring = false
		end
	end

	-- Reduce CPU load
	nanosleep(tsp)

until false
-- End main loop

