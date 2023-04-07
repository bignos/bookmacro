---
-- Macro Module
-- All methods for Macro management

local Path = require("plenary.path")
local Utils = require("bookmacro.utils")

local data_path = vim.fn.stdpath("data")
local save_file = string.format("%s/bookMacro.json", data_path)

local M = {}

---
-- Save BookMacro to a file
--
-- @param path File where to save BookMacro
function M.save_to(path)
	Path.new(path):write(vim.fn.json_encode(BookMacro), "w")
end

---
-- Save BookMacro to the defaut data file 'bookMacro.json'
function M.save()
	M.save_to(save_file)
end

---
-- Load BookMacro with a file
--
-- [Warning] this method overwrite defaul data file with new data
--
-- @param path File where to load data
-- @return true if data was exported, false if the file is not found
function M.load_from(path)
	local full_path = vim.fn.expand(path)
	if vim.fn.filereadable(full_path) ~= 0 then
		BookMacro = vim.fn.json_decode(Path.new(path):read())
		M.save()
		return true
	else
		vim.api.nvim_err_writeln("File '" .. path .. "' Not found")
		return false
	end
end

---
-- Load BookMacro with the defaut data file 'bookMacro.json'
--
-- @return true if data was loaded, false if the file is not found
function M.load()
	return M.load_from(save_file)
end

function M.get_register_list()
	local output_register = vim.fn.execute("register")

	local registers = {}

	for line in string.gmatch(output_register, "[^\r\n]+") do
		local trimed_str = Utils.triml(line)
		if string.find(trimed_str, '^[cl]  "%a') then
			local clean_entry = string.gsub(trimed_str, [[^.*"(.*)$]], [[%1]])
			table.insert(registers, clean_entry)
		end
	end

	return registers
end

--- 
-- Wrapper to add a string to a register
--
-- @param register The register you want to populate
-- @param string The string you want to add on the register
function M.put_to_register(register, string)
	vim.fn.setreg(register, string)
end

---
-- Add a macro to BookMacro
--
-- @param description The description of the macro
-- @param macro The Macro
function M.insert_macro(description, macro)
	local tuple = {
		description = description,
		macro = macro,
	}
	table.insert(BookMacro, tuple)
end

---
-- Add a macro from register and save to defaut data file 'bookMacro.json'
--
-- @param description The description of the macro
-- @param macro_reg The register where is the macro
function M.insert_and_save_macro(description, macro_reg)
	local macro = vim.fn.getreg(macro_reg)
	M.insert_macro(description, macro)
	M.save()
end

return M
