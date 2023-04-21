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

# 📚 What is BookMacro?

**BookMacro** is a [Neovim](https://neovim.io/) plugin that allows you to save your macros

It allows you to manage **The Book of macros**  
you can:

- **Add** a macro to the _Book_
- **Execute** a macro from the _Book_
- **Edit** a macro from the _Book_
- **Edit** a macro description from the _Book_
- **Edit** a macro from a _named register_
- **Replace** a macro from the _Book_ with a _named register_
- **Delete** a macro from the _Book_
- **Load** a macro from the _Book_ into a _named register_
- **Export** the _Book_ to a JSON file
- **Export** a macro to a JSON file
- **Import** the _Book_ from a JSON file
- **Import** the _Book_ from an _URL_
- **Import** a macro from a JSON file
- **Import** a macro from an _URL_
- **Erase** the _Book_
- **Substitute** on a _named register_

![Macro Execution](https://user-images.githubusercontent.com/43069553/233655609-96ea8d3b-7665-42c6-9031-27435285e153.gif)


# 🔰 Getting Started

## ⚡️ Required dependencies

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) To make it easier to read and save files

## 🍉 Suggested dependencies

- [Dressing.nvim](https://github.com/stevearc/dressing.nvim) for a better **TUI**(Terminal User Interface)

## 📦 Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
    "bignos/bookmacro",
    requires = { { "nvim-lua/plenary.nvim" } },
    setup = function()
        require("bookmacro").setup()
    end,
})
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
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

## ⚙️ Configuration

<details>
<summary>My <a href="https://github.com/folke/lazy.nvim" >lazy.nvim</a> configuration</summary>

```lua
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

            -- Execute a macro
            {
                "<leader>Mx",
                vim.cmd.MacroExec,
                desc = "Execute a macro from BookMacro",
            },

            -- Add a macro
            {
                "<leader>Ma",
                vim.cmd.MacroAdd,
                desc = "Add a macro to BookMacro",
            },

            -- Edit a macro
            {
                "<leader>Me",
                vim.cmd.MacroEdit,
                desc = "Edit a macro from BookMacro",
            },
            -- Edit the description of a macro
            {
                "<leader>Md",
                vim.cmd.MacroDescEdit,
                desc = "Edit a description of a macro from BookMacro",
            },

            -- Edit a register
            {
                "<leader>Mr",
                vim.cmd.MacroRegEdit,
                desc = "Edit a macro from register",
            },

            -- Replace a macro with a register
            {
                "<leader>MR",
                vim.cmd.MacroReplace,
                desc = "Replace a macro from BookMacro with the content of a register",
            },

            -- Delete a macro
            {
                "<leader>MD",
                vim.cmd.MacroDel,
                desc = "Delete a macro from BookMacro",
            },

            -- Export BookMacro
            {
                "<leader>MX",
                vim.cmd.MacroExport,
                desc = "Export BookMacro to a JSON file",
            },

            -- Export a Macro
            {
                "<leader>Mz",
                vim.cmd.MacroExportTo,
                desc = "Export a macro to a JSON file",
            },

            -- Import a BookMacro
            {
                "<leader>MI",
                vim.cmd.MacroImport,
                desc = "Import BookMacro with a JSON file",
            },

            -- Import BookMacro from an Internet url
            {
                "<leader>MU",
                vim.cmd.MacroImportInternet,
                desc = "Import BookMacro from an URL",
            },


            -- Import a macro
            {
                "<leader>MZ",
                vim.cmd.MacroImportFrom,
                desc = "Import a macro from a JSON file",
            },

            -- Import a macro from Internet
            {
                "<leader>Mu",
                vim.cmd.MacroImportFromInternet,
                desc = "Import a macro from an URL",
            },

            -- Erase BookMacro
            {
                "<leader>ME",
                vim.cmd.MacroErase,
                desc = "Erase all macros from The Book",
            },

            -- Register substitution
            {
                "<leader>Ms",
                vim.cmd.RegSub,
                desc = "Use substitution on register",
            },
        },
        init = function()
            require("bookmacro").setup()
        end,
    },
}
```
</details>


# 🚀 Usage

## 💻 Commands

- `:MacroAdd` to add a macro on BookMacro
- `:MacroExec` to execute a macro from BookMacro
- `:MacroEdit` to edit a macro from BookMacro
- `:MacroDescEdit` to edit the description of a macro from BookMacro
- `:MacroRegEdit` to edit a macro from a Register
- `:MacroReplace` to replace a macro from BookMacro with a register
- `:MacroDel` to remove a macro from BookMacro
- `:MacroSelect` to add a macro from BookMacro to a register
- `:MacroExport` to export BookMacro to a file
- `:MacroExportTo` to export a macro to a file
- `:MacroImport` to import Bookmacro from a file
- `:MacroImportInternet` to import Bookmacro from an URL
- `:MacroImportFrom` to import a macro from a file
- `:MacroImportFromInternet` to import a macro from an URL
- `:MacroErase` to erase all BookMacro entries
- `:RegSub` to use regexp substitution on a register
- `:Sr <register> <pattern>` to use regexp substitution on a register in **command mode**
    - **Example**: `:Sr a /this/thag/g` to substitute 'this' with 'that' on **register A**

# ▶️ Alternatives

- [nvim-recorder](https://github.com/chrisgrieser/nvim-recorder): Enhance the usage of macros in Neovim
- [Macrobatics.vim](https://github.com/svermeulen/vim-macrobatics): Making VIM macros easier to use
- [MARVIM](https://github.com/chamindra/marvim): Store complex VIM macros and templates into persistent storage for future search and load
