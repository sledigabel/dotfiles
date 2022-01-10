require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 2000,
	},
})

require("gitlinker").setup({
	opts = {
		action_callback = require("gitlinker.actions").copy_to_clipboard,
		print_url = false,
	},
  callbacks = {
    ["github.skyscannertools.net"] = require"gitlinker.hosts".get_github_type_url,
  }
})
