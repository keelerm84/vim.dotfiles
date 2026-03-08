return {
  { "towolf/vim-helm", enabled = function() return require("config.packs").is_enabled("helm") end },
}
