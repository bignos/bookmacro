local Path = require("plenary.path")
local Utils = require("bookmacro.utils")

local data_path = vim.fn.stdpath("data")
local save_file = string.format("%s/bookMacro.json", data_path)

local M = {}

function M.save_to(path)
	Path.new(path):write(vim.fn.json_encode(BookMacro), "w")
end

function M.save()
	M.save_to(save_file)
end

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

function M.put_to_register(register, string)
	vim.fn.setreg(register, string)
end

function M.insert_macro(description, macro)
	local tuple = {
		description = description,
		macro = macro,
	}
	table.insert(BookMacro, tuple)
end

function M.insert_and_save_macro(description, macro_reg)
	local macro = vim.fn.getreg(macro_reg)
	M.insert_macro(description, macro)
	M.save()
end

function M.get_from_user(prompt, func)
	vim.ui.input({
		prompt = prompt,
	}, func)
end

function M.get_from_user_with_default(prompt, default, func)
	vim.ui.input({
		prompt = prompt,
		default = default,
	}, func)
end

function M.get_file_from_user(prompt, default, completion, func)
	vim.ui.input({
		prompt = prompt,
		default = default,
		completion = completion,
	}, func)
end

return M
