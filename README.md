# Neovim Configuration #

This repository contains my Neovim configuration. It is structured as a castle for the [homeshick](https://github.com/andsens/homeshick) tool, which allows easy management for dotfile repos.

## Features ##

This Neovim configuration is built with modern plugin management and customization in mind, supporting user-specific extensions through local configuration.

## Local Configuration (`local.lua`) ##

The `local.lua` file is an optional configuration file that allows users to provide their own plugins and an `after_load` function. This file is not included in the repository by default, as it is intended for user-specific customizations.

### Structure of `local.lua` ###

The `local.lua` file should return a table with the following structure:

```lua
return {
    plugins = {
        -- List of plugins to load
    },
    after_load = function()
        -- Code to execute after the configuration is loaded
    end,
}
```

### Example `local.lua` ###

Here is an example of how you can define your own `local.lua` file:

```lua
return {
    plugins = {
        { "tpope/vim-surround" },
        { "junegunn/fzf", run = function() vim.fn["fzf#install"]() end },
        { import = "plugins.local" },
    },
    after_load = function()
        print("Custom configuration loaded!")
    end,
}
```

## Installation ##

This configuration can be installed using homeshick. Once installed, the Neovim configuration will be placed in `~/.config/nvim`.
