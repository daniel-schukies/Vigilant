-- config.lua
--
-- These variables are exported to all scripts


--------------------------- HARDWARE SETTINGS --------------------------

-- Video device to grab the signal from
VideoDeviceMount 		= "/dev/video0"

-- Which video stream to select from the device
-- Common avaliable stream formats are YUV, YUY2, MJPG, H264
VideoDeviceStream		= "h264"

-- Which GPIO pin sould be configured for sensor input
SensorInputPin 			= 4



--------------------------- RECORDING SETTINGS -------------------------

-- Time in seconds for how long the Record will continue after receiving
-- the stop signal from the sensor.
RecordStopDelay 		= 3

-- Where to put the video files (absolute path).
VideoOutputDir			= "/var/www/html/Videos/"

-- How long to keep video files (days)
KeepVideoDays			= 7


----------------------------- VIDEO SETTINGS ---------------------------

-- In which resolution to record from the video device
VideoCaptureWidth 		= 1280
VideoCaptureHeight		= 720

-- Capture video with this framerate
VideoCaptureFramerate 	= 60


---------------------------- DATABASE SETTINGS -------------------------

-- Hostname of the MySQL server
MySQLDBHostName			= "localhost"

-- Listen port of the MySQL server
-- default is 3306
MySQLDBHostPort			= 3306

-- MySQL username
MySQLDBUserName			= "phpwebuser"

-- This placeholder is NOT a secure password!
-- Change on setup!!!
MySQLDBUserPassword		= "secure_password"	

-- Overrides
--
--RecordDBName		= "Records"
