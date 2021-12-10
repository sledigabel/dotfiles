require("tmux").setup({
  copy_sync = {
    enable = false,
    redirect_to_clipboard = false,
    sync_clipboard = false,
    sync_unnamed = false,
  },
  navigation = {
    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = true,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = true,
  }
})
