return {
  { "hashivim/vim-terraform", enabled = function() return require("config.packs").is_enabled("terraform") end },
}
