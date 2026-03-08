local M = {}

-- Always-installed parsers needed for neovim core functionality
local BASE_PARSERS = { "vim", "vimdoc" }

local languages = {
  bash = {
    mason = { "bashls", "beautysh", "shfmt" },
    formatters = { sh = { "beautysh", "shfmt" }, zsh = { "shfmt" } },
    linters = {},
    parsers = { "bash" },
  },
  brightscript = {
    mason = { "bright_script", "brighterscript-formatter" },
    formatters = { brightscript = { "bsfmt" } },
    linters = {},
    parsers = {},
  },
  c = {
    mason = { "clangd" },
    formatters = {},
    linters = {},
    parsers = { "c", "cpp" },
  },
  csharp = {
    mason = { "omnisharp" },
    formatters = {},
    linters = {},
    parsers = { "c_sharp" },
  },
  dart = {
    mason = {},
    formatters = {},
    linters = {},
    parsers = { "dart" },
  },
  docker = {
    mason = { "dockerls" },
    formatters = {},
    linters = {},
    parsers = { "dockerfile" },
  },
  elixir = {
    mason = {},
    formatters = {},
    linters = {},
    parsers = { "elixir" },
  },
  go = {
    mason = { "gopls", "gofumpt", "goimports", "golangci-lint" },
    formatters = { go = { "gofumpt", "goimports" } },
    linters = { go = { "golangcilint" } },
    parsers = { "go", "gomod", "gosum", "gotmpl", "gowork" },
  },
  graphql = {
    mason = {},
    formatters = {},
    linters = {},
    parsers = { "graphql" },
  },
  haskell = {
    mason = { "hls", "fourmolu" },
    formatters = { haskell = { "fourmolu" } },
    linters = {},
    parsers = { "haskell" },
  },
  helm = {
    mason = { "helm_ls", "trivy" },
    formatters = {},
    linters = { helm = { "trivy" } },
    parsers = { "helm" },
  },
  html = {
    mason = { "html", "cssls" },
    formatters = {},
    linters = {},
    parsers = { "html", "css", "scss" },
  },
  java = {
    mason = { "jdtls", "google-java-format", "sonarlint-language-server" },
    formatters = {},
    linters = {},
    parsers = { "java" },
  },
  javascript = {
    mason = { "ts_ls", "eslint_d", "prettierd", "prettier", "stimulus_ls" },
    formatters = { javascript = { "prettierd", "prettier", stop_after_first = true } },
    linters = { javascript = { "eslint_d" }, javascriptreact = { "eslint_d" } },
    parsers = { "javascript" },
  },
  json = {
    mason = { "jsonls", "jq", "prettierd", "prettier" },
    formatters = { json = { "jq", "prettierd", "prettier", stop_after_first = true } },
    linters = {},
    parsers = { "json" },
  },
  latex = {
    mason = { "ltex" },
    formatters = {},
    linters = {},
    parsers = { "latex" },
  },
  lua = {
    mason = { "lua_ls", "stylua" },
    formatters = { lua = { "stylua" } },
    linters = {},
    parsers = { "lua" },
  },
  make = {
    mason = { "checkmake" },
    formatters = {},
    linters = { make = { "checkmake" } },
    parsers = { "make" },
  },
  php = {
    mason = { "intelephense", "php-cs-fixer" },
    formatters = { php = { "php_cs_fixer" } },
    linters = {},
    parsers = { "php", "phpdoc", "twig" },
  },
  protobuf = {
    mason = { "buf" },
    formatters = {},
    linters = {},
    parsers = { "proto" },
  },
  python = {
    mason = { "ruff", "pylsp", "pyright", "black", "isort" },
    formatters = { python = { "isort", "black" } },
    linters = { python = { "pylint" } },
    parsers = { "python" },
  },
  ruby = {
    mason = { "rubocop" },
    formatters = { ruby = { "rubocop" } },
    linters = {},
    parsers = { "ruby" },
  },
  rust = {
    mason = { "rust_analyzer" },
    formatters = { rust = { "rustfmt" } },
    linters = {},
    parsers = { "rust" },
  },
  shell = {
    mason = { "beautysh", "shfmt" },
    formatters = { sh = { "beautysh", "shfmt" }, zsh = { "shfmt" } },
    linters = {},
    parsers = { "bash" },
  },
  sql = {
    mason = { "sqlls", "sqlfluff" },
    formatters = {},
    linters = { sql = { "sqlfluff" } },
    parsers = { "sql" },
  },
  starlark = {
    mason = { "starpls" },
    formatters = {},
    linters = {},
    parsers = { "starlark" },
  },
  swift = {
    mason = {},
    formatters = {},
    linters = {},
    parsers = { "swift" },
  },
  terraform = {
    mason = { "terraformls" },
    formatters = {},
    linters = {},
    parsers = { "terraform", "hcl" },
  },
  typescript = {
    mason = { "ts_ls", "eslint_d", "prettierd", "prettier" },
    formatters = { typescript = { "prettierd", "prettier", stop_after_first = true } },
    linters = { typescript = { "eslint_d" }, typescriptreact = { "eslint_d" } },
    parsers = { "typescript", "tsx" },
  },
  yaml = {
    mason = { "prettierd", "prettier" },
    formatters = { yaml = { "prettierd", "prettier", stop_after_first = true } },
    linters = {},
    parsers = { "yaml" },
  },
  zig = {
    mason = { "zls" },
    formatters = {},
    linters = {},
    parsers = { "zig" },
  },
}

local _enabled = {}

function M.setup(setting)
  _enabled = {}
  if setting == ":all" then
    for lang in pairs(languages) do
      _enabled[lang] = true
    end
  elseif type(setting) == "table" then
    for _, lang in ipairs(setting) do
      _enabled[lang] = true
    end
  end
end

function M.is_enabled(lang)
  return _enabled[lang] == true
end

function M.get_mason_tools()
  local seen = {}
  local tools = {}
  for lang, _ in pairs(_enabled) do
    local pack = languages[lang]
    if pack then
      for _, tool in ipairs(pack.mason) do
        if not seen[tool] then
          seen[tool] = true
          table.insert(tools, tool)
        end
      end
    end
  end
  return tools
end

function M.get_formatters_by_ft()
  local result = {}
  for lang, _ in pairs(_enabled) do
    local pack = languages[lang]
    if pack then
      for ft, formatters in pairs(pack.formatters) do
        if not result[ft] then
          result[ft] = formatters
        end
      end
    end
  end
  return result
end

function M.get_linters_by_ft()
  local result = {}
  for lang, _ in pairs(_enabled) do
    local pack = languages[lang]
    if pack then
      for ft, linters in pairs(pack.linters) do
        if not result[ft] then
          result[ft] = linters
        end
      end
    end
  end
  return result
end

function M.get_parsers()
  local seen = {}
  local parsers = {}
  for _, p in ipairs(BASE_PARSERS) do
    if not seen[p] then
      seen[p] = true
      table.insert(parsers, p)
    end
  end
  for lang, _ in pairs(_enabled) do
    local pack = languages[lang]
    if pack then
      for _, p in ipairs(pack.parsers) do
        if not seen[p] then
          seen[p] = true
          table.insert(parsers, p)
        end
      end
    end
  end
  return parsers
end

return M
