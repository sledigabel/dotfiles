vim.cmd([[
augroup JsonnetFiles
  autocmd!
  autocmd BufReadPre *.jsonnet setfiletype jsonnet
  autocmd BufReadPre *.libsonnet setfiletype jsonnet
augroup END
]])

-- vim.cmd([[
-- augroup filetype_golang
--     autocmd!
--     autocmd BufWritePre *.go :silent! lua require('go.format').gofmt()
--     autocmd BufWritePre *.go :silent! lua require('go.format').goimport()
-- augroup END
-- ]])
