local navic = require 'nvim-navic'

local on_attach_normal = function(client, bufnr)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "single", focusable = false }
  )
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "single", focusable = false }
  )

  navic.attach(client, bufnr)
end

require("go").setup({
  goimport = 'gopls',
  gofmt = 'gofumpt',
  comment_placeholder = '   ',
  lsp_cfg = true, -- false: use your own lspconfig
  lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
  lsp_codelens = true,
  lsp_on_attach = on_attach_normal, -- use on_attach from go.nvim
  dap_debug = false,
})

vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

-- require("go.format").gofmt()  -- gofmt only
-- require("go.format").goimport()  -- goimport + gofmt
