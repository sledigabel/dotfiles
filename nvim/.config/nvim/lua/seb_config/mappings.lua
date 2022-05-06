-- general
-- vim.o.colorcolumn = "80"
-- vim.cmd([[highlight ColorColumn ctermbg=#1E1E28 guibg=#1E1E28 ]])
vim.o.formatoptions = "cqrn1"
vim.o.number = true
vim.o.numberwidth = 4
vim.o.paste = false
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.swapfile = true
vim.cmd([[
  set signcolumn=yes
]])

-- search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

-- autoindent
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.shiftround = false

-- mouse
vim.o.mouse = "a"

-- directory settings
vim.o.directory = "/Users/sebastienledigabel/.vim/tmp/"

-- highlight the yanking
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}]])


vim.api.nvim_set_keymap("v", "<lt>", "<lt>gv", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

-- CTRL-E
vim.api.nvim_set_keymap("i", "<C-e>", "<Esc>A", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-a>", "<Esc>I", { noremap = true })

-- Savings
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {})
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", {})

-- Clipping
vim.api.nvim_set_keymap("i", "<C-x><C-p>", "<cmd>Telescope neoclip<CR>", { noremap = true, silent = true })

-- CTRL-P
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<cr>", { noremap = true })
