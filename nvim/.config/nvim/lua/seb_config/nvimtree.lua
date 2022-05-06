require("nvim-tree").setup({
	hijack_cursor = true,
	view = {
	-- 	auto_resize = true,
	},
  renderer = {
    indent_markers = {
      enable = false,
    },
  },
	actions = {
    open_file = {
      quit_on_open = true,
    }
  },
})
