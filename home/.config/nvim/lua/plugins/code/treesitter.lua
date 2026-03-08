return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      "sainnhe/gruvbox-material",
    },
    lazy = false,
    config = function()
      -- Gruvbox material color customization
      local configuration = vim.fn["gruvbox_material#get_configuration"]()
      local palette = vim.fn["gruvbox_material#get_palette"](
        configuration.background,
        configuration.foreground,
        configuration.colors_override
      )

      vim.api.nvim_set_hl(0, "@variable.php", { fg = palette.blue[1] })

      -- Install parsers
      require("nvim-treesitter").install(require("config.packs").get_parsers())
    end,
    build = ':TSUpdate',
  },
}
