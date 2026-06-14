local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'Google Sans Code'
config.font_size = 17.0

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

-- initial scheme at launch
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- live-switch when GNOME toggles dark/light
wezterm.on('window-config-reloaded', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local scheme = scheme_for_appearance(window:get_appearance())
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

return config
