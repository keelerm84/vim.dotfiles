return {
  { "weihanglo/polar.vim", enabled = function() return require("config.packs").is_enabled("ruby") end },
  { "olimorris/neotest-rspec", enabled = function() return require("config.packs").is_enabled("ruby") end },
}
