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


-- Codeium
vim.g.codeium_enabled = false
-- function to check if Codeium is toggled
function CheckCodeium()
  if vim.g.codeium_enabled == nil then
    return true
  end
  return vim.g.codeium_enabled
end

function ToggleCodeium()
  if CheckCodeium() then
    vim.g.codeium_enabled = false
  else
    vim.g.codeium_enabled = true
  end
end

-- Command to toggle Codeium
vim.api.nvim_create_user_command("CodeiumToggle", ToggleCodeium, {})

-- change the codeium highlight group
vim.api.nvim_set_hl(0, 'CodeiumSuggestion', { fg = "#656c79", italic = true })
