vim.cmd([[
augroup JsonnetFiles
  autocmd!
  autocmd BufReadPre *.jsonnet setfiletype jsonnet
  autocmd BufReadPre *.libsonnet setfiletype jsonnet
augroup END
]])
