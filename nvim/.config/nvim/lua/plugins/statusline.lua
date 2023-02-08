return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"sam4llis/nvim-tundra",
			"Exafunction/codeium.vim",
			-- "SmiteshP/nvim-navic",
		},
		config = function()
			local lualine_theme = "auto"

			if vim.g.theme == "tundra" then
				local tundra_theme = require("lualine.themes.tundra")
				local cp = require("nvim-tundra.palette." .. vim.g.tundra_biome)
				--
				tundra_theme.normal = {
					a = { fg = cp.indigo._900, bg = cp.indigo._500, gui = "bold" },
					b = { fg = cp.indigo._500, bg = cp.transparent, gui = "bold" },
					c = { fg = cp.indigo._300, bg = cp.transparent },
				}

				lualine_theme = tundra_theme
			end

      print(lualine_theme)

			require("lualine").setup({
				options = {
					globalstatus = true,
					section_separators = "",
					theme = lualine_theme,
					component_separators = "",
					-- section_separators = { left = '', right = '' },
					-- component_separators = { left = '', right = '' },
					-- section_separators = { left = '', right = '' },
					-- component_separators = { left = '', right = '' },
				},
				sections = {
					lualine_a = {
						-- { 'mode', separator = { left = '', right = '' }, right_padding = 2, }
						{ "mode", right_padding = 2 },
					},
					lualine_b = {
						{
							"branch",
							-- icon = "",
							icon = "",
							padding = 2,
						},
						{
							"diff",
							symbols = { added = " ", modified = "柳", removed = " " },
							padding = 2,
						},
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
					lualine_c = {},
					lualine_x = { "filetype", "progress" },
					lualine_y = { "StatusCodeium()" },
					-- lualine_z = { { "location", separator = { left = '' } } },
					lualine_z = { { "location" } },
				},
			})

			-- vim.o.winbar = "     %-50(%#BufferLineHintSelected#%{%v:lua.require'nvim-navic'.get_location()%}%)"
		end,
		priority = 1,
	},
}
