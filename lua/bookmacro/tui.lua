---
-- TUI Module
-- Terminal User Interface methods

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
-- Remove a Macro from BookMacro
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
-- Erase The Book
-- Ask confirmation
function M.eraseMacro()
	local confirm = vim.fn.confirm("Erase The Book?", "&Yes\n&No")
	if confirm == 1 then -- If user respond Yes
        Macro.erase_the_book()
	end
end

return M
