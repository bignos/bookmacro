<h1 align="center">
                                   BookMacro 
</h1>

<p align="center">
    <img src="bookMacro.png" alt="BookMacro logo" title="BookMacro logo">
</p>

<p align="center">
                                Save Your Magic
</p>

---

# What is BookMacro?

**BookMacro** is a [Neovim](https://neovim.io/) plugin that allows you to save your macros

It allows you to manage a list of macros, you can:
- Add a macro to the list
- Remove a macro from the list
- Load a macro from the list into a named register

![select_macro](https://user-images.githubusercontent.com/43069553/229956541-b0025501-baad-4583-be44-7ff4d96750cc.gif)

# Getting Started

## Required dependencies

* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) To make it easier to read and save files

## Suggested dependencies

* [Dressing.nvim](https://github.com/stevearc/dressing.nvim) for a better **TUI**(Terminal User Interface)

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
``` lua
use({
    "bignos/bookmacro",
    requires = { { "nvim-lua/plenary.nvim" } },
    setup = function()
        require("bookmacro").setup()
    end,
})
```
Using [lazy.nvim](https://github.com/folke/lazy.nvim)

``` lua
return {
    {
        "bignos/bookmacro",
        dependencies = { "nvim-lua/plenary.nvim" },
        init = function()
            require("bookmacro").setup()
        end,
    },
}
```

## Configuration

My [lazy.nvim](https://github.com/folke/lazy.nvim) configuration

``` lua
return {
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
}
```

# Usage

## Commands

- `:MacroAdd` to add a macro on BookMacro
- `:MacroDel` to remove a macro from BookMacro
- `:MacroSelect` to add a macro from BookMacro to a registry
