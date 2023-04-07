local Macro = require("bookmacro.macro")

local M = {}

BookMacro = BookMacro or {}

function M.setup()
	Macro.load()

	-- Declaration of user commands
	vim.api.nvim_create_user_command("MacroAdd", function()
		M.addMacro()
	end, { desc = "Add a macro to BookMacro" })

	vim.api.nvim_create_user_command("MacroEdit", function()
		M.editMacro()
	end, { desc = "Edit a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroRegEdit", function()
		M.editRegMacro()
	end, { desc = "Edit a macro from a register" })

	vim.api.nvim_create_user_command("MacroDel", function()
		M.removeMacro()
	end, { desc = "Delete a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroSelect", function()
		M.selectMacro()
	end, { desc = "Select a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroExport", function()
		M.exportMacro()
	end, { desc = "Export BookMacro to a JSON file" })

	vim.api.nvim_create_user_command("MacroImport", function()
		M.importMacro()
	end, { desc = "Replace BookMacro with a JSON file" })
end

function M.addMacro()
	local register_list = Macro.get_register_list()
	vim.ui.select(register_list, {
		prompt = "Select a Macro",
	}, function(macro, _)
		if macro then
			local register = string.sub(macro, 1, 1)
			Macro.get_from_user("Macro description", function(description)
				if description then
					Macro.insert_and_save_macro(description, register)
				end
			end)
		end
	end)
end

function M.editMacro()
	vim.ui.select(BookMacro, {
		prompt = "Edit a Macro",
		format_item = function(item)
			return item.description .. " >> '" .. item.macro .. "'"
		end,
	}, function(macro, idx)
		if macro then
			Macro.get_from_user_with_default("New Macro:", macro.macro, function(edited_macro)
				if edited_macro then
					BookMacro[idx].macro = edited_macro
					Macro.save()
				end
			end)
		end
	end)
end

function M.editRegMacro()
	local register_list = Macro.get_register_list()
	vim.ui.select(register_list, {
		prompt = "Edit a Macro from register",
	}, function(macro, _)
		if macro then
			local register = string.sub(macro, 1, 1)
			local registry_content = vim.fn.getreg(register)

			Macro.get_from_user_with_default("New Macro:", registry_content, function(edited_macro)
				if edited_macro then
					Macro.put_to_register(register, edited_macro)
				end
			end)
		end
	end)
end

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

function M.selectMacro()
	vim.ui.select(BookMacro, {
		prompt = "Select a Macro",
		format_item = function(item)
			return item.description
		end,
	}, function(macro, idx)
		if macro then
			Macro.get_from_user("Macro register:", function(register)
				if register then
					Macro.put_to_register(register, BookMacro[idx].macro)
				end
			end)
		end
	end)
end

function M.exportMacro()
	Macro.get_file_from_user("Export BookMacro", "bookmacro.json", "file", function(file)
		if file then
			Macro.save_to(file)
			print("Export to " .. file .. " [ DONE ]")
		end
	end)
end

function M.importMacro()
	Macro.get_file_from_user("Import file to BookMacro", "", "file", function(file)
		if file and Macro.load_from(file) then
			print("Import " .. file .. " [ DONE ]")
		end
	end)
end

-- Main
M.setup()

return M
