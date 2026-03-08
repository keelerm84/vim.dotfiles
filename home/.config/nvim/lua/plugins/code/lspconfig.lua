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

          require("mason-tool-installer").setup({
            ensure_installed = require("config.packs").get_mason_tools(),
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
