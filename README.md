# Neovim Configuration #

This repository contains my Neovim configuration. It is structured as a castle for the [homeshick](https://github.com/andsens/homeshick) tool, which allows easy management for dotfile repos.

## Features ##

This Neovim configuration is built with modern plugin management and customization in mind, supporting user-specific extensions through local configuration.

## Local Configuration (`local.lua`) ##

The `local.lua` file is an optional configuration file that allows users to customize language support, add plugins, and run code after load. This file is not included in the repository by default.

### Structure of `local.lua` ###

```lua
return {
    language_packs = ":all",  -- see Language Packs section below
    plugins = {},
    after_load = function() end,
}
```

### Language Packs ###

All language-specific tooling (LSP servers, formatters, linters, treesitter parsers, and lang plugins) is gated behind a `language_packs` setting. This makes it easy to share the config with others who don't want every language tool installed.

**Install everything (original behavior):**
```lua
language_packs = ":all"
```

**Install only specific languages:**
```lua
language_packs = { "go", "rust", "lua" }
```

**Install specific languages with overrides for one or more packs:**

Mix plain strings (use defaults) with config tables (override specific fields). Any field you omit falls back to the pack's defaults.

```lua
language_packs = {
    "rust",
    "lua",
    {
        name = "go",
        -- only install gopls; skip gofumpt, goimports, golangci-lint
        mason = { "gopls" },
        -- keep default formatters and parsers (omitted = use defaults)
    },
    {
        name = "python",
        -- swap black/isort for ruff-only formatting
        formatters = { python = { "ruff" } },
    },
}
```

The overridable fields per pack are:

| Field | Type | Description |
|-------|------|-------------|
| `mason` | `string[]` | Mason package names to install |
| `formatters` | `{ [filetype]: string[] }` | conform `formatters_by_ft` entries |
| `linters` | `{ [filetype]: string[] }` | nvim-lint `linters_by_ft` entries |
| `parsers` | `string[]` | Treesitter parser names |

**Install nothing language-specific** (omit the key, or set it to an empty table):
```lua
language_packs = {}
```

#### Available pack names ####

| Pack | Tools included |
|------|---------------|
| `bash` | bashls, beautysh, shfmt |
| `brightscript` | bright_script, brighterscript-formatter |
| `c` | clangd |
| `csharp` | omnisharp |
| `dart` | dart parser |
| `docker` | dockerls |
| `elixir` | elixir parser |
| `go` | gopls, gofumpt, goimports, golangci-lint, neotest-golang |
| `graphql` | graphql parser |
| `haskell` | hls, fourmolu |
| `helm` | helm_ls, trivy |
| `html` | html, cssls |
| `java` | jdtls, google-java-format, sonarlint |
| `javascript` | ts_ls, eslint_d, prettierd/prettier, stimulus_ls |
| `json` | jsonls, jq, prettierd/prettier |
| `latex` | ltex |
| `lua` | lua_ls, stylua |
| `make` | checkmake |
| `php` | intelephense, php-cs-fixer, neotest-phpunit |
| `protobuf` | buf |
| `python` | ruff, pylsp, pyright, black, isort, neotest-python |
| `ruby` | rubocop, neotest-rspec |
| `rust` | rust_analyzer, rustaceanvim |
| `shell` | beautysh, shfmt |
| `sql` | sqlls, sqlfluff |
| `starlark` | starpls |
| `swift` | swift parser |
| `terraform` | terraformls |
| `typescript` | ts_ls, eslint_d, prettierd/prettier |
| `yaml` | prettierd/prettier |
| `zig` | zls |

Note: `javascript` and `typescript` share tools (ts_ls, eslint_d, prettierd); duplicates are deduplicated automatically.

### Example `local.lua` ###

```lua
return {
    language_packs = { "go", "lua", "rust" },
    plugins = {
        { "tpope/vim-surround" },
    },
    after_load = function()
        print("Custom configuration loaded!")
    end,
}
```

## Installation ##

This configuration can be installed using homeshick. Once installed, the Neovim configuration will be placed in `~/.config/nvim`.
