local wezterm = require 'wezterm'
local M = {}

function M.setup(config)
  config.keys = {
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = wezterm.action.CopyTo "Clipboard",
    },
  }
end

return M