-- options generales, font, padding, opacity --

local M = {}

function M.setup(config)
-- Automatically Reload Configurations
config.automatically_reload_config = true

-- Options générales (exemples utiles)
config.check_for_updates = false
config.enable_scroll_bar = false
config.scrollback_lines = 5000

end

return M