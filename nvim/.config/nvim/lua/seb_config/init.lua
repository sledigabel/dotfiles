vim.g.mapleader = ' '
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {})
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", {})

require 'seb_config.plugins'
require 'seb_config.treesitter'
require 'seb_config.mappings'
require 'seb_config.colorscheme'
require 'seb_config.telescope'
require 'seb_config.comment'
require 'seb_config.gitsigns'
require 'seb_config.lsp'
require 'seb_config.tmux'
require 'seb_config.completion'
