# Claude Code Guidelines

## Language Pack System

All language-specific tooling is managed through `lua/config/packs.lua`. When adding support for a new language, every piece of that language's tooling must be registered there — do not hardcode tools in individual plugin files.

### Adding a new language pack

1. **Register the pack in `lua/config/packs.lua`**

   Add an entry to the `languages` table:

   ```lua
   mylang = {
     mason    = { "mylang-lsp", "mylang-formatter" },    -- mason-tool-installer package names
     formatters = { mylang = { "mylang_fmt" } },         -- conform formatters_by_ft entries
     linters    = { mylang = { "mylang_lint" } },        -- nvim-lint linters_by_ft entries
     parsers    = { "mylang" },                          -- treesitter parser names
   },
   ```

   - `mason` keys are mason package names (use the exact string mason-tool-installer expects)
   - `formatters` keys are filetypes, values are conform formatter lists
   - `linters` keys are filetypes, values are nvim-lint linter lists
   - `parsers` are treesitter parser names (as used by `:TSInstall`)
   - Any field can be an empty table `{}` if unused

2. **Create `lua/plugins/lang/mylang.lua`**

   Gate every plugin spec with an `enabled` guard:

   ```lua
   return {
     {
       "author/mylang-plugin",
       enabled = function() return require("config.packs").is_enabled("mylang") end,
     },
   }
   ```

   If the language has a neotest adapter, add it here (not in `neotest.lua`):

   ```lua
   {
     "author/neotest-mylang",
     enabled = function() return require("config.packs").is_enabled("mylang") end,
   },
   ```

3. **`neotest.lua` loads adapters dynamically via `pcall`** — no changes needed there unless adding a new adapter module name to the `try_adapter` calls.

4. **Update the README** — add a row to the pack table in the Language Packs section.

### Key files

| File | Purpose |
|------|---------|
| `lua/config/packs.lua` | Central registry and API (`setup`, `is_enabled`, `get_mason_tools`, `get_formatters_by_ft`, `get_linters_by_ft`, `get_parsers`) |
| `lua/config/init.lua` | Calls `packs.setup(config.language_packs)` before lazy setup |
| `lua/plugins/code/lspconfig.lua` | Uses `get_mason_tools()` for mason-tool-installer |
| `lua/plugins/code/formatter.lua` | Uses `get_formatters_by_ft()` for conform |
| `lua/plugins/code/nvim-lint.lua` | Uses `get_linters_by_ft()` for nvim-lint |
| `lua/plugins/code/treesitter.lua` | Uses `get_parsers()` for treesitter install |
| `lua/plugins/code/neotest.lua` | Dynamically loads adapters via `pcall` |
| `lua/plugins/lang/*.lua` | One file per language; all specs gated with `enabled` |

### `local.lua` interface

Users configure language support via `lua/local.lua` (not tracked in the repo):

```lua
return {
    language_packs = ":all",   -- or { "go", "rust" }, or {} for nothing
    plugins = {},
    after_load = function() end,
}
```

- `":all"` — enable every pack in the registry
- `{ "go", "rust" }` — only those packs
- `{}` or key absent — no language tooling installed

Two packs (e.g. `javascript` and `typescript`) can safely declare overlapping mason tools or formatters — `get_mason_tools()` and `get_parsers()` deduplicate, and `get_formatters_by_ft()`/`get_linters_by_ft()` use first-one-wins per filetype.
