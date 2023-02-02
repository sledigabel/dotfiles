local wk = require("which-key")
wk.setup({
  plugins = {
    marks = false,
    registers = false,
  },
  window = {
    border = "double",
  },
})

-- Leader key normal mode
wk.register({
  b = { "<cmd>Telescope buffers<cr>", "Buffers" },
  B = {
    name = "debugger",
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint", },
    B = { "<cmd>Telescope dap list_breakpoints<cr>", "Breakpoint", },
    c = { "<cmd>lua require('dap').continue()<cr>", "Continue", },
    C = { "<cmd>Telescope dap commands<cr>", "Continue", },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into", },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over", },
    O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out", },
    s = { "<cmd>lua require'dap'.close()<cr>", "Stop", },
    p = { "<cmd>lua require('dap-python').test_method()<cr>", "Python test", },
    u = { "<cmd>DapUiToggle<cr>", "UI Toggle", },
  },
  c = {
    ["aw"] = {
      '<cmd>lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false) end end<cr>',
      "Close all windows",
    },
  },
  d = { "<cmd>bd<cr>", "Delete buffer" },
  f = {
    name = "Telescope",
    ["."] = {
      "<cmd>Telescope find_files hidden=true cwd=~/.config/nvim no_ignore=true find_command=fd,-e,lua<cr>",
      "Neovim files",
    },
    a = { "<cmd>lua require('telescope.builtin').live_grep({hidden=true})<cr>", "Grep files" },
    c = { "<cmd>lua require('telescope').extensions.gh.gist()<cr>", "Gists" },
    i = { "<cmd>lua require('telescope').extensions.gh.issues()<cr>", "Github issues" },
    f = { "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", "Find files" },
    g = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "Git files" },
    o = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Symbols" },
    p = { "<cmd>lua require('telescope').extensions.gh.pull_requests()<cr>", "Pull requests" },
    r = { "<cmd>lua require('telescope').extensions.gh.run()<cr>", "Runs" },
  },
  g = {
    name = "Lsp",
    a = { "<cmd>lua require('lspsaga.codeaction').code_action()<cr>", "CodeActions" },
    c = { "<cmd>CodeiumToggle<cr>", "CodeActions" },
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
    D = { "<cmd>Lspsaga preview_definition<cr>", "Saga Definition" },
    e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show line diagnostics" },
    f = { "<cmd>NvimTreeFindFile<cr>", "Find file" },
    g = { "<cmd>:Git<cr>", "Git" },
    h = { "<cmd>lua require'lspsaga.provider'.lsp_finder()<cr>", "Saga Finder" },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementations" },
    o = { "<cmd>lua io.popen('gh pr view -w')<cr>", "Open PR in web" },
    q = { "<cmd>TroubleToggle<cr>", "Diag list" },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
    t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type definition" },
    w = {
      name = "Workspaces",
      a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add" },
      r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove" },
      l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List" },
    },
  },
  l = {
    f = { "<cmd>lua vim.lsp.buf.format { async = true }<cr>", "Formatting" },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Set Location list" },
  },
  p = {
    name = "Neoclip",
    p = { "<cmd>Telescope neoclip<cr>", "Neoclip" },
  },
  r = {
    n = { "<cmd>Lspsaga rename<cr>", "Rename" },
  },
  t = {
    name = "NvimTree", -- optional group name
    d = { "<cmd>:DapUiToggle<cr>", "Toggle DAP UI" },
    t = { "<cmd>:NvimTreeToggle<cr>", "Toggle NvimTree" }, -- create a binding with label
  },
  y = { '"*y', "Copy to the clipboard" },
  ["/"] = { "<cmd>normal yyPgccj<cr>", "Copy and comment" },
}, { prefix = "<leader>", noremap = true })

-- Leader key visual mode
wk.register({
  y = { '"*y', "Copy to clipboard" },
}, { prefix = "<leader>", noremap = true, mode = "v" })

-- Various mappings
wk.register({
  ["gd"] = { "<Cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
  ["K"] = { "<Cmd>Lspsaga hover_doc<cr>", "Signature" },
  ["[g"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev diag" },
  ["]g"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diag" },
  ["[b"] = { "<cmd>BufferLineCyclePrev<cr>", "Prev buffer" },
  ["]b"] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
  ["<C-u>"] = { "<C-u>zz", "scroll up" },
  ["<C-d>"] = { "<C-d>zz", "scroll down" },
  ["<C-s>"] = { ":w<cr>", "save" },
  ["<C-p>"] = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "git files" },
}, { noremap = true, mode = "n" })

wk.register({
  ["K"] = { ":m '<-2<CR>gv=gv", "Moves the selection one line up" },
  ["J"] = { ":m '>+1<CR>gv=gv", "Moves selection one line down" },
  ["<lt>"] = { "<lt>gv", "Tab in" },
  [">"] = { ">gv", "Tab out" },
}, { noremap = true, mode = "v" })

wk.register({
  ["<C-e>"] = { "<esc>A", "Skips to the end of the line" },
  ["<C-a>"] = { "<esc>I", "Get back to the beginning of the line" },
  ["<C-j>"] = { '<esc>:lua require("tmux").move_bottom()<cr>', "Window down" },
  ["<C-h>"] = { '<esc>:lua require("tmux").move_left()<cr>', "Window left" },
  ["<C-k>"] = { '<esc>:lua require("tmux").move_top()<cr>', "Window up" },
  ["<C-l>"] = { '<esc>:lua require("tmux").move_right()<cr>', "Window right" },
  ["<C-s>"] = { '<esc>:w<cr>', "save" },
  ["<C-x><C-p>"] = { '<cmd>Telescope neoclip<CR>', "Neoclip" },
  -- ["<C-/>"] = { function() vim.api.nvim_call_function("codeium#Accept", {}) print("Accept!") end, "Codeium Complete" },
}, { noremap = true, mode = "i" })

vim.cmd("imap <script><silent><nowait><expr> <C-x><C-x> codeium#Accept()")






