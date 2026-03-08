return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local adapters = {}
      local function try_adapter(mod, setup_fn)
        local ok, m = pcall(require, mod)
        if ok then table.insert(adapters, setup_fn and setup_fn(m) or m) end
      end
      try_adapter("neotest-golang", function(m) return m({ runner = "gotestsum" }) end)
      try_adapter("rustaceanvim.neotest")
      try_adapter("neotest-rspec")
      try_adapter("neotest-python", function(m) return m({ dap = { justMyCode = false }, runner = "pytest" }) end)
      try_adapter("neotest-phpunit")
      require("neotest").setup({ adapters = adapters })
    end,
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "[t]est [a]ll files",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "[t]est run [f]ile",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "[t]est [s]uite",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "[t]est [n]earest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "[t]est [l]ast",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.attach()
        end,
        desc = "[t]est [A]ttach",
      },
      {
        "<leader>tS",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "[t]est [S]ummary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "[t]est [o]utput",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "[t]est [O]utput panel",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.stop()
        end,
        desc = "[t]est [t]erminate",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ suite = false, strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
    },
  },
}
