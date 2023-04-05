<h1 align="center">
                                   BookMacro 
</h1>

<p align="center">
    <img src="bookMacro.png" alt="BookMacro logo" title="BookMacro logo">
</p>

Save your Neovim Macros

![select_macro](https://user-images.githubusercontent.com/43069553/229956541-b0025501-baad-4583-be44-7ff4d96750cc.gif)

# Dependencies

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) To make it easier to read and save files

# Setup

## Lazy

``` lua
{
	"bignos/bookmacro",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		-- Load a macro
		{
			"<leader>Ml",
			vim.cmd.MacroSelect,
			desc = "Load a macro to a registry",
		},

		-- Add a macro
		{
			"<leader>Ma",
			vim.cmd.MacroAdd,
			desc = "Add a macro to BookMacro",
		},

		-- Delete a macro
		{
			"<leader>Md",
			vim.cmd.MacroDel,
			desc = "Delete a macro from BookMacro",
		},
	},
	init = function()
		require("bookmacro").setup()
	end,
},
```
# Commands

- `:MacroAdd` to add a macro on BookMacro
- `:MacroDel` to remove a macro from BookMacro
- `:MacroSelect` to add a macro from BookMacro to a registry
