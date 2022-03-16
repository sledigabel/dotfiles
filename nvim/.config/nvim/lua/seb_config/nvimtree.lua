require("nvim-tree").setup({
	auto_close = true,
	hijack_cursor = true,
	view = {
		auto_resize = true,
	},
	actions = {
    open_file = {
      quit_on_open = true,
    }
  },
})
