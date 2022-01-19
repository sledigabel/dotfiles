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
		lualine_x = { "filetype" },
	},
})
