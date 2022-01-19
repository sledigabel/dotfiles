require("lualine").setup({
	sections = {
		lualine_b = {
			{
				"branch",
				icon = "",
			},
			"diff",
			{
				"diagnostics",
				sources = { "nvim_diagnostic", "nvim_lsp" },
				symbols = {
					error = " ",
					warn = " ",
					hint = " ",
					info = " ",
				},
			},
		},
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				path = 0, -- 0: Just the filename
				-- 1: Relative path
				-- 2: Absolute path

				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				symbols = {
					modified = " ", -- Text to show when the file is modified.
					readonly = " ", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
				},
			},
		},
		lualine_x = { "filetype" },
	},
})
