---
-- BookMacro Main Module

local Macro = require("bookmacro.macro")
local TUI = require("bookmacro.tui")

local M = {}

-- [CONST]

-- https://www.npoint.io/docs/81b5e2d91a75af3485ea
DefaultMacroURL = "https://api.npoint.io/81b5e2d91a75af3485ea"

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

	vim.api.nvim_create_user_command("MacroExec", function()
		TUI.executeMacro()
	end, { desc = "Execute a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroEdit", function()
		TUI.editMacro()
	end, { desc = "Edit a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroDescEdit", function()
		TUI.editMacroDescription()
	end, { desc = "Edit a description of a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroRegEdit", function()
		TUI.editRegMacro()
	end, { desc = "Edit a macro from a register" })

	vim.api.nvim_create_user_command("MacroReplace", function()
		TUI.replaceMacroWithReg()
	end, { desc = "Replace a macro from BookMacro with a register" })

	vim.api.nvim_create_user_command("MacroDel", function()
		TUI.removeMacro()
	end, { desc = "Delete a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroSelect", function()
		TUI.selectMacro()
	end, { desc = "Select a macro from BookMacro" })

	vim.api.nvim_create_user_command("MacroExport", function()
		TUI.exportMacro()
	end, { desc = "Export BookMacro to a JSON file" })

	vim.api.nvim_create_user_command("MacroExportTo", function()
		TUI.exportMacroTo()
	end, { desc = "Export a macro to a JSON file" })

	vim.api.nvim_create_user_command("MacroImport", function()
		TUI.importMacro()
	end, { desc = "Replace BookMacro with a JSON file" })

	vim.api.nvim_create_user_command("MacroImportInternet", function()
		TUI.importMacroInternet()
	end, { desc = "Replace with a JSON from Internet" })

	vim.api.nvim_create_user_command("MacroImportFrom", function()
		TUI.importMacroFrom()
	end, { desc = "Import a macro from a JSON file" })

	vim.api.nvim_create_user_command("MacroImportFromInternet", function()
		TUI.importMacroFromInternet()
	end, { desc = "Import a macro from the Internet" })

	vim.api.nvim_create_user_command("MacroErase", function()
		TUI.eraseMacro()
	end, { desc = "Erase all macro from BookMacro" })
end

M.setup()

return M
