-- contexte machine --

local wezterm = require 'wezterm'
local M = {}

local hostname = wezterm.hostname()

M.is_vm = hostname:match("rstudio") ~= nil
M.is_fydeos = wezterm.target_triple == "x86_64-unknown-linux-gnu"
M.low_ram = tonumber(wezterm.get_env("WEZTERM_LOW_RAM") or "0") == 1

return M
