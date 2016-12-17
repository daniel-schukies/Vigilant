-- dbclean.lua
--


require "config"
require "init"

local qresult = conn:execute("SELECT * FROM Records WHERE DATEDIFF(NOW(),RecordDateTime)>="..KeepVideoDays..";")
local nrow = {}
while qresult:fetch(nrow, "a") ~= nil do
	if nrow['VideoPath'] ~= "" and nrow['VideoPath'] ~= nil then
		print("RM "..VideoOutputDir..nrow['VideoPath'])
		-- Delete video file
		os.remove(""..VideoOutputDir..nrow['VideoPath'])
		-- NULL DB entry
		conn:execute("UPDATE Records SET VideoPath=NULL WHERE EntryID="..nrow['EntryID']..";")
	end
end
qresult:close()
os.exit(0)
