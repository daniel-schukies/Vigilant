-- init.lua
--
--

require "config"



-- import POSIX core functions
unistd = require "posix.unistd"
sig = require "posix.signal"
fdopen = require "posix.stdio".fdopen
nanosleep = require "posix.time".nanosleep

-- luaSQL setup
local dMySQL = require "luasql.mysql"
local env = assert(dMySQL.mysql())

conn = env:connect(RecordDBName or "Records", 
			 MySQLDBUserName,
			 MySQLDBUserPassword,
			 MySQLDBHostName,
			 MySQLDBHostPort or 3306)

autocommitEnabled = conn:setautocommit(true)

-- Failsafe SQL commit function
function commit()
	if autocommitEnabled then return
	else
		return conn:commit()
	end
end


-- Initialize GPIO
local export = io.open("/sys/class/gpio/export","w")
export:write(tostring(SensorInputPin))
export:close()
local actlow = io.open("/sys/class/gpio/gpio"..tostring(SensorInputPin).."/active_low")
actlow:write(tostring(1))
actlow:close()
