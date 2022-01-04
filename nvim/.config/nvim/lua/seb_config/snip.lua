-- require('Luasnip').setup({})
require("luasnip/loaders/from_vscode").lazy_load({
	paths = { "./friendly-snippets" },
})

-- 	elseif luasnip.expand_or_jumpable() then
-- 		luasnip.expand_or_jump()
vim.api.nvim_set_keymap(
	"i",
	"<C-Space>",
	"<cmd>lua ls = require('luasnip'); if ls.expand_or_jumpable() then ls.expand_or_jump() end<CR>",
	{ noremap = true }
)
