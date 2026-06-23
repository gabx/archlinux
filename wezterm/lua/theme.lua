-- selection de theme --
-- Test colorthemes: % bash -c "$(wget -qO- https://git.io/vQgMr)"

local wezterm = require 'wezterm'
local env = require 'lua.env'

local themes = {
  desktop = require 'lua.themes.catppuccin',
  vm      = require 'lua.themes.gruvbox',
  lowram  = require 'lua.themes.nord',
}

local M = {}

function M.setup(config)
  if env.is_vm then
    themes.vm.apply(config)
  elseif env.low_ram then
    themes.lowram.apply(config)
  else
    themes.desktop.apply(config)
  end
end

return M