vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

-- local border = {
--       {"┌", "FloatBorder"},
--       {"─", "FloatBorder"},
--       {"┐", "FloatBorder"},
--       {"│", "FloatBorder"},
--       {"┘", "FloatBorder"},
--       {"─", "FloatBorder"},
--       {"└", "FloatBorder"},
--       {"│", "FloatBorder"},
-- }

local border = "double"
local nvim_lsp = require("lspconfig")
local lsp_signature = require("lsp_signature")

lsp_signature.setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	handler_opts = {
		border = "rounded",
	},
	floating_window_above_cur_line = false,
})

local on_attach = function(client, bufnr)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = border, focusable = false }
	)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = border, focusable = false }
	)
	-- require('completion').on_attach()

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings
	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  --
  --
	-- -- Set some keybinds conditional on server capabilities
	-- if client.resolved_capabilities.document_formatting then
	--     buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	-- elseif client.resolved_capabilities.document_range_formatting then
	--     buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	-- end

	-- -- Set autocommands conditional on server_capabilities
	-- if client.resolved_capabilities.document_highlight then
	--     require('lspconfig').util.nvim_multiline_command [[
	--     :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
	--     :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
	--     :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
	--     augroup lsp_document_highlight
	--         autocmd!
	--         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
	--         autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
	--     augroup END
	--     ]]
	-- end
	-- lsp_signature.on_attach()
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.pylsp.setup({
	on_attach = on_attach,
	cmd = { "/Users/sebastienledigabel/.pyenv/shims/pylsp" },
	capabilities = capabilities,
})

-- nvim_lsp.pyright.setup {
--     on_attach = on_attach,
--     -- capabilities = capabilities,
-- }

nvim_lsp.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
			end,
		},
	},
})

nvim_lsp.jsonnet_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/Users/sebastienledigabel/dev/go/bin/jsonnet-language-server" },
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

-- local servers = { 'gopls', 'rust_analyzer', 'bashls', 'yamlls', 'jsonnet_ls', 'sumneko_lua' }
local servers = { "gopls", "rust_analyzer", "bashls", "yamlls", "jsonnet_ls" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	local hl2 = "LspDiagnosticsSign" .. type
	vim.fn.sign_define(hl2, { text = icon, texthl = hl2, numhl = "" })
end

local M = {}

M.icons = {
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Enum = "了 ",
	EnumMember = " ",
	Field = " ",
	File = " ",
	Folder = " ",
	Function = " ",
	Interface = "ﰮ ",
	Keyword = " ",
	Method = "ƒ ",
	Module = " ",
	Property = " ",
	Snippet = "﬌ ",
	Struct = " ",
	Text = " ",
	Unit = " ",
	Value = " ",
	Variable = " ",
}

-- function M.setup()
--   local kinds = vim.lsp.protocol.CompletionItemKind
--   for i, kind in ipairs(kinds) do
--     kinds[i] = M.icons[kind] or kind
--   end
-- end

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Could be '●', '▎', 'x', '■'
	},
})


return M
