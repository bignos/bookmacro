---
-- Utils Module

local M = {}

---
-- Trim left 
-- remove useless space on left of a string
--
-- @param str The string to trim
-- @return The trimed string
function M.triml(str)
	return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

return M
