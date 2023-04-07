---
-- BookMacro Main Module

local Macro = require("bookmacro.macro")
local TUI = require("bookmacro.tui")

local M = {}

-- Global data container
BookMacro = BookMacro or {}

---
-- Plugin initialisation
--
-- Load BookMacro file
-- Declare user commands
function M.setup()
	Macro.load()

	-- [ User Commands ]
	vim.api.nvim_create_user_command("MacroAdd", function()
		TUI.addMacro()
	end, { desc = "Add a macro to BookMacro" })

	vim.api.nvim_create_user_command("MacroEdit", function()
		TUI.editMacro()
	end, { desc = "Edit a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroRegEdit", function()
		TUI.editRegMacro()
	end, { desc = "Edit a macro from a register" })

	vim.api.nvim_create_user_command("MacroDel", function()
		TUI.removeMacro()
	end, { desc = "Delete a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroSelect", function()
		TUI.selectMacro()
	end, { desc = "Select a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroExport", function()
		TUI.exportMacro()
	end, { desc = "Export BookMacro to a JSON file" })

	vim.api.nvim_create_user_command("MacroImport", function()
		TUI.importMacro()
	end, { desc = "Replace BookMacro with a JSON file" })
end

M.setup()

return M
