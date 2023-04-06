local Path = require("plenary.path")

local data_path = vim.fn.stdpath("data")
local save_file = string.format("%s/bookMacro.json", data_path)

local M = {}

BookMacro = BookMacro or {}

-- Private

local function triml(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

local function save_to(path)
	Path.new(path):write(vim.fn.json_encode(BookMacro), "w")
end

local function save()
    save_to(save_file)
end

local function load_from(path)
	if vim.fn.filereadable(path) ~= 0 then
		BookMacro = vim.fn.json_decode(Path.new(path):read())
        save()
	end
end

local function load()
    load_from(save_file)
end

local function get_register_list()
    local output_register = vim.fn.execute("register")

    local registers = {}

    for line in string.gmatch(output_register, "[^\r\n]+") do
        local trimed_str = triml(line)
        if string.find(trimed_str, "^c ") and string.find(trimed_str, "\"%a") then
            local clean_entry = string.gsub(trimed_str, [[^.*"(.*)$]], [[%1]])
            table.insert(registers, clean_entry)
        end
    end

    return registers
end

local function put_to_register(register, string)
	vim.fn.setreg(register, string)
end

local function insert_macro(description, macro)
	local tuple = {
		description = description,
		macro = macro,
	}
	table.insert(BookMacro, tuple)
end

local function insert_and_save_macro(description, macro_reg)
	local macro = vim.fn.getreg(macro_reg)
	insert_macro(description, macro)
    save()
end

local function get_from_user(prompt, func)
	vim.ui.input({
		prompt = prompt,
	}, func)
end

local function get_file_from_user(prompt, default, completion, func)
	vim.ui.input({
		prompt = prompt,
        default = default,
        completion = completion,
	}, func)
end

-- Public
function M.setup()
    load()

    -- Declaration of user commands
    vim.api.nvim_create_user_command('MacroAdd', function()
        M.addMacro()
    end, { desc = "Add a macro to BookMacro" })

    vim.api.nvim_create_user_command('MacroDel', function()
        M.removeMacro()
    end, { desc = "Delete a macro from BookMacro" })

    vim.api.nvim_create_user_command('MacroSelect', function()
        M.selectMacro()
    end, { desc = "Select a macro from BookMacro" })

    vim.api.nvim_create_user_command('MacroExport', function()
        M.exportMacro()
    end, { desc = "Export BookMacro to a JSON file" })

    vim.api.nvim_create_user_command('MacroImport', function()
        M.importMacro()
    end, { desc = "Replace BookMacro with a JSON file" })
end

function M.addMacro()
    local register_list = get_register_list()
	vim.ui.select(register_list, {
		prompt = "Select a Macro",
	}, function(macro, _)
		if macro then
            local register = string.sub(macro,1,1)
			get_from_user("Macro description", function(description)
				if description then
					insert_and_save_macro(description, register)
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
            save()
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
			get_from_user("Macro register:", function(register)
				if register then
					put_to_register(register, BookMacro[idx].macro)
				end
			end)
		end
	end)
end

function M.exportMacro()
    get_file_from_user("Export BookMacro", "bookmacro.json", "file", function(file)
        if file then
            save_to(file)
            print("Export to " .. file .. " [ DONE ]")
        end
    end
    )
end

function M.importMacro()
    get_file_from_user("Import file to BookMacro", "", "file", function(file)
        if file then
            load_from(file)
            print("Import " .. file .. " [ DONE ]")
        end
    end
    )
end

-- Main
M.setup()

return M
