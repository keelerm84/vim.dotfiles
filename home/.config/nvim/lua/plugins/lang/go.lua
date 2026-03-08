return {
  {
    "ray-x/go.nvim",
    enabled = function() return require("config.packs").is_enabled("go") end,
    dependencies = {
      "ray-x/guihua.lua",
    },
    opts = {},
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "fredrikaverpil/neotest-golang",
    enabled = function() return require("config.packs").is_enabled("go") end,
    build = function()
      vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
    end,
  },
}
