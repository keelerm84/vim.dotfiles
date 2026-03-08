return {
  { "lumiliet/vim-twig", enabled = function() return require("config.packs").is_enabled("php") end },
  { "olimorris/neotest-phpunit", enabled = function() return require("config.packs").is_enabled("php") end },
}
