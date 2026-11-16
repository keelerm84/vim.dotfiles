return {
  { "neovim/nvim-lspconfig" },
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require("mason").setup()

          -- Mason has no linux-arm64 builds of these tools.
          local no_arm64 = { clangd = true, starpls = true, checkmake = true, fourmolu = true }
          local is_arm64 = vim.uv.os_uname().machine == "aarch64"

          require("mason-tool-installer").setup({
            ensure_installed = vim.tbl_filter(function(tool)
              return not (is_arm64 and no_arm64[tool])
            end, {
              --
              -- Linter, Formatter, & LSP
              --
              "ruff",

              --
              -- LSP
              --
              "bashls",
              "bright_script",
              "clangd",
              "cssls",
              "dockerls",
              "gopls",
              "helm_ls",
              "hls",
              "html",
              "intelephense",
              "jsonls",
              "jdtls",
              "ltex",
              "lua_ls",
              "omnisharp",
              "phpactor",
              "pylsp",
              "pyright",
              "rust_analyzer",
              "starpls",
              "solargraph",
              "sqlls",
              "stimulus_ls",
              "terraformls",
              "ts_ls",
              "zls",

              --
              -- Linter
              --
              "checkmake",
              "eslint_d",
              "golangci-lint",
              "sonarlint-language-server",
              "sqlfluff",

              --
              -- Linter + Formatter
              --
              "buf",

              --
              -- Formatter only
              --
              "beautysh",
              "black",
              "brighterscript-formatter",
              "fourmolu",
              "gofumpt",
              "goimports",
              "google-java-format",
              "isort",
              "jq",
              "php-cs-fixer",
              "prettierd",
              "prettier",
              "rubocop",
              "shfmt",
              "stylua",
              "trivy",
            }),
          })

          require("mason-lspconfig").setup()

          vim.lsp.config("lua_ls", {
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
              },
            },
          })

          vim.lsp.config("intelephense", {
            settings = {
              intelephense = {
                format = {
                  enable = false,
                },
              },
            },
          })

          vim.lsp.config("stylua", {
            settings = {
              indent_type = "Spaces",
            },
          })
        end,
      },
    },
    init = function()
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    end,
  },
}
