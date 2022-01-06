vim.g.vscode_style = "dark"

local catppuccin = require("catppuccin")

catppuccin.setup({
	transparent_background = true,
	integrations = {
		treesitter = true,
		native_lsp = {
			enabled = true,
		},
		cmp = true,
		lsp_saga = true,
		gitsigns = true,
		telescope = true,
		nvimtree = {
			enabled = true,
			show_root = true,
		},
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
	},
})
vim.cmd([[colorscheme catppuccin]])

-- vim.cmd([[colorscheme gruvbox-material]])
-- vim.g.gruvbox_material_background = 'medium'
-- vim.g.gruvbox_material_enable_italic = true
-- vim.g.gruvbox_material_enable_bold = true

-- vim.cmd([[colorscheme OceanicNext]])

-- Set transparency
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi LineNr guibg=NONE ctermbg=NONE]])
vim.cmd([[hi SignColumn guibg=NONE ctermbg=NONE]])
vim.cmd([[hi EndOfBuffer guibg=NONE ctermbg=NONE]])
