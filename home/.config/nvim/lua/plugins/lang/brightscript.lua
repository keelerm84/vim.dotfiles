return {
  { "entrez/roku.vim", enabled = function() return require("config.packs").is_enabled("brightscript") end },
}
