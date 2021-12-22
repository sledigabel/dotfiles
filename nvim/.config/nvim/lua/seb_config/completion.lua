vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

local lspkind = require("lspkind")
lspkind.init()

local cmp = require("cmp")
-- local luasnip = require("luasnip")

-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			-- For `vsnip` user.
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

			-- For `luasnip` user.
			-- require('luasnip').lsp_expand(args.body)

			-- For `ultisnips` user.
			-- vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		-- { name = 'vsnip' },
		{ name = "calc" },
		{ name = "emoji" },
		-- { name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "buffer" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
				gh_issues = "[issues]",
				tn = "[TabNine]",
			},
		}),
	},
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
