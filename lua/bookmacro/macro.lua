---
-- Macro Module
-- All methods for Macro management
--
-- Need CONST:
--  -> BookMacro

local Path = require("plenary.path")
local Curl = require("plenary.curl")
local Utils = require("bookmacro.utils")

local data_path = vim.fn.stdpath("data")
local save_file = string.format("%s/bookMacro.json", data_path)

local M = {}

---
-- Save an Array to a JSON File
--
-- @param array An Array
-- @param file The path of the file to save
function M.save_array_to_file(array, file)
	Path.new(file):write(vim.fn.json_encode(array), "w")
end

---
-- Save BookMacro to a file
--
-- @param path File where to save BookMacro
function M.save_to(path)
    M.save_array_to_file(BookMacro, path)
end

---
-- Save BookMacro to the defaut data file 'bookMacro.json'
function M.save()
	M.save_to(save_file)
end

---
-- Get a macro JSON file
--
-- @param path File where to load data from
-- return The array of macro or an empty array in case of error
function M.get_macro_file(path)
    local result = {}
    local full_path = vim.fn.expand(path)
	if vim.fn.filereadable(full_path) ~= 0 then
		result = vim.fn.json_decode(Path.new(path):read())
	else
		vim.api.nvim_err_writeln("File '" .. path .. "' Not found")
	end
    return result
end

---
-- Load an url with JSON content and return an array
--
-- @param url The url to load
-- @return An array with all data from Internet
function M.get_macro_from_url(url)
    local result = Curl.get(url, {accept= "application/json"})
    return vim.fn.json_decode(result.body)
end

---
-- Replace the content of BookMacro with an array
--
-- [Warning] this method overwrite defaul data file with new data
--
-- @array The macro array to replace BookMacro
-- @return true if BookMacro was replaced, false if the array is empty
function M.replace_with_array(array)
    if next(array) ~= nil then
        BookMacro = array
        M.save()
        return true
    else
        return false
    end
end

---
-- Load BookMacro with a file
--
-- [Warning] this method overwrite defaul data file with new data
--
-- @param path File where to load data from
-- @return true if data was exported, false if the file is not found
function M.load_from(path)
    local loaded_file = M.get_macro_file(path)
    return M.replace_with_array(loaded_file)
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
			local clean_entry = string.gsub(trimed_str, [[^[cl]  "(.*)$]], [[%1]])
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
-- Add a macro to an Array
--
-- @param array The array to append
-- @param description The description of the macro
-- @param macro The Macro
function M.insert_macro_to_array(array, description, macro)
	local tuple = {
		description = description,
		macro = macro,
	}
	table.insert(array, tuple)
end

---
-- Add a macro to BookMacro
--
-- @param description The description of the macro
-- @param macro The Macro
function M.insert_macro(description, macro)
    M.insert_macro_to_array(BookMacro, description, macro)
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

---
-- Replace a macro in BookMacro
--
-- @param index Index of the macro from BookMacro
-- @param new_macro New macro to relace
function M.replace_macro(index, new_macro)
    BookMacro[index].macro = new_macro
end

---
-- Execute a macro
--
-- @param macro The macro to execute
function M.execute(macro)
    vim.cmd("silent normal " .. macro)
end

---
-- Execute a macro from BookMacro
--
-- @param index The index of the macro from BookMacro
function M.execute_from_index(index)
    M.execute(BookMacro[index].macro)
end

---
-- Erase all BookMacro entries
--
-- Warning: All macros will be lost
function M.erase_the_book()
    local size = #BookMacro
    for index=0, size do
        BookMacro[index] = nil
    end
    M.save()
end

return M
