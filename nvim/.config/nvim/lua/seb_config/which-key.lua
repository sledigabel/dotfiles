local wk = require("which-key")
wk.setup({})

-- Leader key normal mode
wk.register({
	b = { "<cmd>Telescope buffers<cr>", "Buffers" },
	c = {
		["aw"] = {
			'<cmd>lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false) end end<cr>',
			"Close all windows",
		},
	},
	d = { "<cmd>bd<cr>", "Delete buffer" },
	f = {
		name = "Telescope",
		["."] = {
			"<cmd>Telescope find_files hidden=true cwd=~/.config/nvim no_ignore=true find_command=fd,-e,lua<cr>",
			"Neovim files",
		},
		a = { "<cmd>lua require('telescope.builtin').live_grep({hidden=true})<cr>", "Grep files" },
		c = { "<cmd>lua require('telescope').extensions.gh.gist()<cr>", "Gists" },
		i = { "<cmd>lua require('telescope').extensions.gh.issues()<cr>", "Github issues" },
		f = { "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", "Find files" },
		g = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "Git files" },
		o = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Symbols" },
		p = { "<cmd>lua require('telescope').extensions.gh.pull_requests()<cr>", "Pull requests" },
		r = { "<cmd>lua require('telescope').extensions.gh.run()<cr>", "Runs" },
	},
	g = {
		name = "Lsp",
		d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
		D = { "<cmd>Lspsaga preview_definition<cr>", "Saga Definition" },
		e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show line diagnostics" },
		f = { "<cmd>NvimTreeFindFile<cr>", "Find file" },
		g = { "<cmd>:Git<cr>", "Git" },
		h = { "<cmd>lua require'lspsaga.provider'.lsp_finder()<cr>", "Saga Finder" },
		i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementations" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Diag list" },
		r = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
		t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type definition" },
		w = {
			name = "Workspaces",
			a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add" },
			r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove" },
			l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List" },
		},
	},
	l = {
		f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Formatting" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Set Location list" },
	},
	p = {
		name = "Neoclip",
		p = { "<cmd>Telescope neoclip<cr>", "Neoclip" },
	},
	r = {
		n = { "<cmd>Lspsaga rename<cr>", "Rename" },
	},
	t = {
		name = "NvimTree", -- optional group name
		t = { "<cmd>:NvimTreeToggle<cr>", "Toggle NvimTree" }, -- create a binding with label
	},
	y = { '"*y', "Copy to the clipboard" },
	["/"] = { "<cmd>normal yyPgccj<cr>", "Copy and comment" },
}, { prefix = "<leader>", noremap = true })

-- Leader key visual mode
wk.register({
	y = { '"*y', "Copy to clipboard" },
}, { prefix = "<leader>", noremap = true, mode = "v" })

-- Various mappings
wk.register({
	["gd"] = { "<Cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
	["K"] = { "<Cmd>Lspsaga hover_doc<cr>", "Signature" },
	["[g"] = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Prev diag" },
	["]g"] = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Prev diag" },
}, { noremap = true, mode = "n" })
