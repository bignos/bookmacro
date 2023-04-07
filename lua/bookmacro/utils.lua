local M = {}

function M.triml(str)
	return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

return M
