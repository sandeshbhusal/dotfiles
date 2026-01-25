local wezterm = require 'wezterm'
local config = {}

-- Use the config_builder init if available for better error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- =========================================================================
-- Visual Configuration
-- =========================================================================

-- Font Configuration
-- Ensure "Google Sans Code" is installed on your system.
config.font = wezterm.font 'Google Sans Code'
config.font_size = 17.0

-- Color Scheme Handling
-- This function automatically selects a high-contrast scheme based on the OS appearance.
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    -- "Catppuccin Mocha" provides high contrast and clarity for dark mode
    return 'Catppuccin Mocha'
  else
    -- "Catppuccin Latte" is a high-contrast, clear light theme
    return 'Catppuccin Latte'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- Tab Bar Configuration
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- =========================================================================
-- Platform Specifics
-- =========================================================================

-- Detect the operating system
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- Windows: Default to PowerShell
if is_windows then
  config.default_prog = { 'powershell.exe', '-NoLogo' }
end

-- =========================================================================
-- Event Listeners (Dynamic Theme Switching)
-- =========================================================================

-- Poll for system theme changes and update immediately
wezterm.on('window-config-reloaded', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

return config
