vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

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

local lspsaga = require("lspsaga")
lspsaga.init_lsp_saga({
	finder_action_keys = {
		quit = "<Esc>",
		open = "<cr>",
	},
	code_action_keys = {
		quit = "<Esc>",
	},
	rename_action_keys = {
		quit = "<Esc>",
	},
})

local on_attach_normal = function(client, bufnr)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = border, focusable = false }
	)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = border, focusable = false }
	)
end

local on_attach_no_formatting = function(client, bufnr)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = border, focusable = false }
	)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = border, focusable = false }
	)

	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.pylsp.setup({
	on_attach = on_attach_normal,
	cmd = { "/Users/sebastienledigabel/.pyenv/shims/pylsp" },
	capabilities = capabilities,
	settings = {
		pylsp = {
			plugins = {
				configurationSources = { "flake8" },
				flake8 = { enabled = true },
				pycodestyle = { enabled = false },
			},
		},
	},
})

-- nvim_lsp.pyright.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }

nvim_lsp.jsonls.setup({
	on_attach = on_attach_normal,
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
	on_attach = on_attach_normal,
	capabilities = capabilities,
	cmd = { "/Users/sebastienledigabel/dev/go/bin/jsonnet-language-server" },
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach_normal,
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

nvim_lsp.yamlls.setup({
	on_attach = on_attach_normal,
	capabilities = capabilities,
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
			},
		},
	},
})

-- nvim_lsp.gopls.setup({
-- 	on_attach = on_attach_no_formatting,
-- 	capabilities = capabilities,
-- })
-- local servers = { 'gopls', 'rust_analyzer', 'bashls', 'yamlls', 'jsonnet_ls', 'sumneko_lua' }
local servers = { "rust_analyzer", "bashls", "jsonnet_ls" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach_normal,
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

require("trouble").setup({
	height = 4,
})

return M
