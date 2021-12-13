-- augroup vim-jsonnet
--    autocmd!
--    autocmd BufReadPre *.jsonnet setlocal foldmethod=syntax
--    autocmd BufReadPre *.libsonnet setlocal foldmethod=syntax
--    autocmd BufReadPre *.jsonnet setlocal foldlevel=100
--    autocmd BufReadPre *.libsonnet setlocal foldlevel=100
--    autocmd BufWritePre *.jsonnet call s:fmtAutosave()
--    autocmd BufWritePre *.libsonnet call s:fmtAutosave()
-- augroup END


vim.cmd [[
augroup JsonnetFiles
  autocmd!
  autocmd BufReadPre *.jsonnet setfiletype jsonnet
  autocmd BufReadPre *.libsonnet setfiletype jsonnet
augroup END
]]
