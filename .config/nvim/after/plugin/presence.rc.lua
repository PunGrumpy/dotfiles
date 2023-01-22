-- The setup config table shows all available config options with their default values:
require("presence"):setup({
  -- General options
  auto_update        = true,
  neovim_image_text  = "NeoVim",
  main_image         = "file",
  client_id          = "793271441293967371",
  log_level          = nil,
  debounce_timeout   = 10,
  enable_line_number = true,
  blacklist          = {},
  buttons            = true,
  file_assets        = {},
  show_time          = true,

  -- Rich Presence text options
  editing_text        = "Editing %s",
  file_explorer_text  = "Browsing %s",
  git_commit_text     = "Committing changes",
  plugin_manager_text = "Managing plugins",
  reading_text        = "Reading %s",
  workspace_text      = "Working on %s",
  line_number_text    = "Line %s out of %s",
})
