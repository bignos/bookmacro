---
-- TUI Module
-- Terminal User Interface methods
--
-- Need CONST:
--  -> BookMacro
--  -> DefaultMacroURL

local Macro = require("bookmacro.macro")

local M = {}

-- [ Internal function ] --

---
-- TUI promt to ask a string to the user
--
-- @param prompt The prompt to display
-- @param func The function to call when you receive user input
local function get_from_user(prompt, func)
	vim.ui.input({
		prompt = prompt,
	}, func)
end

---
-- TUI promt to ask a string to the user with a defaut input
--
-- @param prompt The prompt to display
-- @param defaut The defaut input
-- @param func The function to call when you receive user input
local function get_from_user_with_default(prompt, default, func)
	vim.ui.input({
		prompt = prompt,
		default = default,
	}, func)
end

-- TUI promt to ask a file to the user with a defaut input
--
-- @param prompt The prompt to display
-- @param defaut The defaut input
-- @param completion The completion type (check `:help :command-complete`)
-- @param func The function to call when you receive user input
local function get_file_from_user(prompt, default, completion, func)
	vim.ui.input({
		prompt = prompt,
		default = default,
		completion = completion,
	}, func)
end

--- 
-- Transform a sustitute pattern to a sustitute function argument
--
-- @param pattern The subsitute pattern
-- @return The argument string for the substitute VIM function
local function transform_substitution_pattern(pattern)
	local separator = string.sub(pattern, 1, 1)
	local list_arg = vim.split(pattern, separator, { true })
	local pat = list_arg[2] or ""
	local substitute = list_arg[3] or ""
	local flags = list_arg[4] or ""
	local result = "'" .. pat .. "', '" .. substitute .. "', '" .. flags .. "'"
	return result
end

-- [ Public methods ] --

---
-- Add a Macro from a register to BookMacro
-- Ask macro description
function M.addMacro()
	local register_list = Macro.get_register_list()
	vim.ui.select(register_list, {
		prompt = "Select a Macro",
	}, function(macro, _)
		if macro then
			local register = string.sub(macro, 1, 1)
			get_from_user("Macro description", function(description)
				if description then
					Macro.insert_and_save_macro(description, register)
				end
			end)
		end
	end)
end

---
-- Execute a Macro from the BookMacro libray
function M.executeMacro()
	vim.ui.select(BookMacro, {
		prompt = "Select a Macro to run",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, idx)
		if macro then
			Macro.execute_from_index(idx)
		end
	end)
end

---
-- Edit a Macro from BookMacro
function M.editMacro()
	vim.ui.select(BookMacro, {
		prompt = "Edit a Macro",
		format_item = function(item)
			return item.description .. " >> '" .. item.macro .. "'"
		end,
	}, function(macro, idx)
		if macro then
			get_from_user_with_default("New Macro:", macro.macro, function(edited_macro)
				if edited_macro then
					BookMacro[idx].macro = edited_macro
					Macro.save()
				end
			end)
		end
	end)
end

---
-- Edit a Description of a Macro from BookMacro
function M.editMacroDescription()
	vim.ui.select(BookMacro, {
		prompt = "Choose a Macro",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, idx)
		if macro then
			get_from_user_with_default("New Description:", macro.description, function(new_description)
				if new_description then
					BookMacro[idx].description = new_description
					Macro.save()
				end
			end)
		end
	end)
end

---
-- Edit a Macro from register
function M.editRegMacro()
	local register_list = Macro.get_register_list()
	vim.ui.select(register_list, {
		prompt = "Edit a Macro from register",
	}, function(macro, _)
		if macro then
			local register = string.sub(macro, 1, 1)
			local registry_content = vim.fn.getreg(register)

			get_from_user_with_default("New Macro:", registry_content, function(edited_macro)
				if edited_macro then
					Macro.put_to_register(register, edited_macro)
				end
			end)
		end
	end)
end

---
-- Replace a Macro from the BookMacro with a register
-- Ask Macro
-- Ask Register
function M.replaceMacroWithReg()
	vim.ui.select(BookMacro, {
		prompt = "Replace which macro",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, idx)
		if macro then
			local register_list = Macro.get_register_list()
			vim.ui.select(register_list, {
				prompt = "With which register",
			}, function(reg, _)
				if reg then
					local register = string.sub(reg, 1, 1)
					local registry_content = vim.fn.getreg(register)
					Macro.replace_macro(idx, registry_content)
					Macro.save()
				end
			end)
		end
	end)
end

---
-- Remove a Macro from BookMacro
-- Ask Macro
function M.removeMacro()
	vim.ui.select(BookMacro, {
		prompt = "Delete a Macro",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, idx)
		if macro then
			table.remove(BookMacro, idx)
			Macro.save()
		end
	end)
end

---
-- Load a Macro from BookMacro to a register
-- Ask register
function M.selectMacro()
	vim.ui.select(BookMacro, {
		prompt = "Select a Macro",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, idx)
		if macro then
			get_from_user("Macro register:", function(register)
				if register then
					Macro.put_to_register(register, BookMacro[idx].macro)
				end
			end)
		end
	end)
end

---
-- Export BookMacro to a JSON file
-- Ask filename
function M.exportMacro()
	get_file_from_user("Export BookMacro", "bookmacro.json", "file", function(file)
		if file then
			Macro.save_to(file)
			print("Export to " .. file .. " [ DONE ]")
		end
	end)
end

---
-- Export a macro from BookMacro to a JSON file
-- Ask macro
-- Ask filename
function M.exportMacroTo()
	vim.ui.select(BookMacro, {
		prompt = "Select a Macro to export",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, _)
		if macro then
			get_file_from_user("Export to file:", "", "file", function(file)
				if file then
					local loaded_file = Macro.get_macro_file(file)
					if next(loaded_file) ~= nil then
						Macro.insert_macro_to_array(loaded_file, macro.description, macro.macro)
						Macro.save_array_to_file(loaded_file, file)
						print("Export Macro [" .. macro.description .. "] to " .. file .. " [ DONE ]")
					end
				end
			end)
		end
	end)
end

---
-- Import from a JSON file to BookMacro
-- Ask file to import
function M.importMacro()
	get_file_from_user("Import file to BookMacro", "", "file", function(file)
		if file and Macro.load_from(file) then
			print("Import " .. file .. " [ DONE ]")
		end
	end)
end

---
-- Import from an Internet JSON file to BookMacro
-- Ask url to import
function M.importMacroInternet()
	get_file_from_user("Internet Macro url:", DefaultMacroURL, "", function(url)
		if url then
			local loaded_url = Macro.get_macro_from_url(url)
			Macro.replace_with_array(loaded_url)
			print("Import " .. url .. " [ DONE ]")
		end
	end)
end

---
-- Import a macro from a JSON file to BookMacro
-- Ask file to import from
function M.importMacroFrom()
	get_file_from_user("Macro file:", "", "file", function(file)
		if file then
			local loaded_file = Macro.get_macro_file(file)
			if next(loaded_file) ~= nil then
				vim.ui.select(loaded_file, {
					prompt = "Select a Macro to import",
					format_item = function(item)
						return item.description
					end,
				}, function(macro, _)
					if macro then
						Macro.insert_macro(macro.description, macro.macro)
						Macro.save()
						print("Import Macro [" .. macro.description .. "] [ DONE ]")
					end
				end)
			end
		end
	end)
end

---
-- Import a macro from an Internet JSON file to BookMacro
-- Ask url to import from
function M.importMacroFromInternet()
	get_file_from_user("Internet Macro url:", DefaultMacroURL, "", function(url)
		if url then
			local loaded_url = Macro.get_macro_from_url(url)
			if next(loaded_url) ~= nil then
				vim.ui.select(loaded_url, {
					prompt = "Select a Macro to import",
					format_item = function(item)
						return item.description
					end,
				}, function(macro, _)
					if macro then
						Macro.insert_macro(macro.description, macro.macro)
						Macro.save()
						print("Import Macro [" .. macro.description .. "] [ DONE ]")
					end
				end)
			end
		end
	end)
end

---
-- Erase The Book
-- Ask confirmation
function M.eraseMacro()
	local confirm = vim.fn.confirm("Erase The Book?", "&Yes\n&No")
	if confirm == 1 then -- If user respond Yes
		Macro.erase_the_book()
	end
end

---
-- Use substitution regex on a register (TUI Version)
-- Ask Register
-- Ask substitution pattern
function M.registerSubstitute()
	local register_list = Macro.get_register_list()
	vim.ui.select(register_list, {
		prompt = "Which register to substitute",
	}, function(reg, _)
		if reg then
			local register = string.sub(reg, 1, 1)
			get_from_user("Substitute pattern", function(s_pattern)
				if s_pattern then
					local sub_arg = transform_substitution_pattern(s_pattern)
					-- let @c=@c->substitute('ABSOLUTE', 'ABIGSOLUTE', 'g')
					local substitution_command = "let @"
						.. register
						.. "=@"
						.. register
						.. "->substitute("
						.. sub_arg
						.. ")"
					vim.cmd(substitution_command)
				end
			end)
		end
	end)
end

---
-- Use substitution regex on a register (Command Version)
-- @param register The register to sustitute
-- @param pattern The sustitution pattern(/<pat>/<sub>/<flags)
function M.regSub(register, pattern)
	local sub_arg = transform_substitution_pattern(pattern)
	local substitution_command = "let @" .. register .. "=@" .. register .. "->substitute(" .. sub_arg .. ")"
	vim.cmd(substitution_command)
end

return M
