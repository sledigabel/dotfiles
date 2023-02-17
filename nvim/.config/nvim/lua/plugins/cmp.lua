return {
	{
		"onsails/lspkind-nvim",
		config = function()
			local lspkind = require("lspkind")
			lspkind.init()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"windwp/nvim-autopairs",
			"onsails/lspkind-nvim",
			"petertriho/cmp-git",
			-- dep
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local lspkind = require("lspkind")
			-- for git
			require("cmp_git").setup()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					-- ["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
					["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
					["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
					["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
					["<C-x><C-d>"] = cmp.mapping.complete(),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer", keyword_length = 5 },
					{ name = "emoji" },
					{ name = "calc" },
					{ name = "git" },
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
							git = "[git]",
						},
					}),
				},
			})

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		end,
	},
}

-- use({ "hrsh7th/nvim-cmp" })
-- use({ "hrsh7th/cmp-path" })
-- use({ "hrsh7th/cmp-buffer" })
-- use({ "hrsh7th/cmp-calc" })
-- use({ "hrsh7th/cmp-emoji" })
-- use({ "hrsh7th/cmp-nvim-lsp" })
-- use({ "hrsh7th/cmp-nvim-lua" })
-- use({ "saadparwaiz1/cmp_luasnip" })
