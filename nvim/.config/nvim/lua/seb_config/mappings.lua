-- general
vim.o.colorcolumn = "80"
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

-- highlight the yanking
vim.cmd[[au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}]]


-- set shortmess+=c
-- " Whitespace
-- 
-- 
-- " move swap files somewhere we dont care about
-- set directory^=$HOME/.vim/tmp//
-- 
-- " general shortuts
-- " for easy copy
-- nnoremap <leader>y "+y
-- vnoremap <leader>y "+y
