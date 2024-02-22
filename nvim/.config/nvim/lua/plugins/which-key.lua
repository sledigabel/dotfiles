return {
  {
    "folke/which-key.nvim",
    config = function()
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

      function select_test_to_run()
        -- test which filetype we are in
        local ft = vim.bo.filetype
        if ft == "go" then
          return vim.cmd([[ GoDebug --test]])
        elseif ft == "python" then
          return require("dap-python").test_method()
        else
          return print("Filetype not supported for unit test")
        end
      end

      function run_local_test()
        local ft = vim.bo.filetype
        if ft == "go" then
          return vim.cmd([[ GoTestFunc ]])
        elseif ft == "python" then
          return require("dap-python").test_method()
        else
          return print("Filetype not supported for unit test")
        end
      end

      function terminate()
        local ft = vim.bo.filetype
        if ft == "go" then
          return vim.cmd([[ GoDebug --stop]])
        else
          return vim.cmd([[ DapTerminate ]])
        end
      end

      function buf_lsp_filter_function(client)
        return client.name ~= "pylsp"
      end

      -- Leader key normal mode
      wk.register({
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        B = {
          name = "debugger",
          B = { "<cmd>Telescope dap list_breakpoints<cr>", "Breakpoint" },
          O = { "<cmd>lua require('dap').step_out()<cr>", "Step Out" },
          b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Breakpoint" },
          c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
          i = { "<cmd>lua require('dap').step_into()<cr>", "Step Into" },
          o = { "<cmd>lua require('dap').step_over()<cr>", "Step Over" },
          p = { "<cmd>lua select_test_to_run()<cr>", "(Debug) Run test" },
          S = { "<cmd>lua terminate()<cr>", "Terminate" },
          t = { "<cmd>Telescope dap commands<cr>", "Commands" },
          u = { "<cmd>lua require('dapui').toggle()<cr>", "UI Toggle" },
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
          O = { "<cmd>ObsidianSearch<cr>", "Obsidian" },
          a = { "<cmd>lua require('telescope.builtin').live_grep({hidden=true})<cr>", "Grep files" },
          c = { "<cmd>lua require('telescope').extensions.gh.gist()<cr>", "Gists" },
          f = { "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", "Find files" },
          g = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "Git files" },
          i = { "<cmd>lua require('telescope').extensions.gh.issues()<cr>", "Github issues" },
          o = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Symbols" },
          p = { "<cmd>lua require('telescope').extensions.gh.pull_requests()<cr>", "Pull requests" },
          r = { "<cmd>lua require('telescope').extensions.gh.run()<cr>", "Runs" },
          s = {
            s = { "<cmd>Scratch<cr>", "New Scratch" },
            n = { "<cmd>ScratchWithName<cr>", "Named Scratch" },
            o = { "<cmd>ScratchOpenFzf<cr>", "Open Scratch" },
          },
          ["ml"] = { "<cmd>CellularAutomaton make_it_rain<cr>", "FML" },
        },
        g = {
          name = "Lsp",
          a = { "<cmd>Lspsaga code_action<cr>", "CodeActions" },
          c = { "<cmd>CodeiumToggle<cr>", "CodeActions" },
          d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
          -- d = { "<cmd>Lspsaga goto_definition<cr>", "Definition" },
          D = { "<cmd>Lspsaga finder<cr>", "Saga Finder" },
          -- e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show line diagnostics" },
          e = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show line diagnostics" },
          f = { "<cmd>NvimTreeFindFile<cr>", "Find file" },
          g = { "<cmd>:Git<cr>", "Git" },
          i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementations" },
          o = { "<cmd>lua io.popen('gh pr view -w')<cr>", "Open PR in web" },
          O = { "<cmd>Lspsaga outline<cr>", "Saga Outline" },
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
          f = { "<cmd>lua vim.lsp.buf.format { async = true, filter = buf_lsp_filter_function }<cr>", "Formatting" },
          q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Set Location list" },
          l = { "<cmd>lua require('telescope').extensions.gen.prompts({ mode = 'n'})<cr>", "LLM Prompts" },
          L = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Restart LspLines" },
        },
        p = {
          name = "Neoclip",
          p = { "<cmd>Telescope neoclip<cr>", "Neoclip" },
        },
        r = {
          n = { "<cmd>Lspsaga rename<cr>", "Rename" },
          N = { "<cmd>Lspsaga rename ++project<cr>", "Rename" },
        },
        s = {
          o = { "<cmd>ScratchOpenFzf<cr>", "Open Scratch" },
          n = { "<cmd>ScratchWithName<cr>", "New Scratch" },
          s = { "<cmd>Scratch<cr>", "Open New Daily Scratch" },
        },
        t = {
          name = "NvimTree", -- optional group name
          d = { "<cmd>:DapUiToggle<cr>", "Toggle DAP UI" },
          t = { "<cmd>:NvimTreeToggle<cr>", "Toggle NvimTree" }, -- create a binding with label
        },
        y = { '"*y', "Copy to the clipboard" },
        ["/"] = { "<cmd>normal yyPgccj<cr>", "Copy and comment" },
        -- K = { require("hover").hover, "hover" },
      }, { prefix = "<leader>", noremap = true })

      -- Leader key visual mode
      wk.register({
        y = { '"*y', "Copy to clipboard" },
        ["lf"] = { "<Esc><cmd>lua vim.lsp.buf.range_formatting()<cr>gv", "Format selection" },
        ["ll"] = { "<cmd>lua require('telescope').extensions.gen.prompts({ mode = 'v'})<cr>", "LLM Prompts" },
      }, { prefix = "<leader>", noremap = true, mode = "v" })

      -- Various mappings
      wk.register({
        ["gd"] = { "<Cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
        -- ["K"] = { "<Cmd>Lspsaga hover_doc ++quiet<cr>", "Signature" },
        K = { require("hover").hover, "hover" },
        ["L"] = { "<Cmd>Lspsaga peek_definition<cr>", "Peek definition" },
        -- ["K"] = { "<Cmd>Lspsaga hover_doc<cr>", "Signature" },
        -- ["K"] = { "<Cmd>lua vim.lsp.buf.hover()<cr>", "Signature" },
        ["[g"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev diag" },
        ["]g"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diag" },
        ["[b"] = { "<cmd>BufferLineCyclePrev<cr>", "Prev buffer" },
        ["]b"] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
        ["<C-u>"] = { "<C-u>zz", "scroll up" },
        ["<C-d>"] = { "<C-d>zz", "scroll down" },
        ["<C-s>"] = { ":w<cr>", "save" },
        ["<C-p>"] = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "git files" },
        ["[["] = { "<cmd>Gitsigns next_hunk<cr>", "[Git] next hunk" },
        ["]]"] = { "<cmd>Gitsigns prev_hunk<cr>", "[Git] previous hunk" },
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
        ["<C-s>"] = { "<esc>:w<cr>", "save" },
        ["<C-x><C-p>"] = { "<cmd>Telescope neoclip<CR>", "Neoclip" },
        ["<C-Space>"] = {
          '<cmd>lua ls = require("luasnip"); if ls.expand_or_jumpable() then ls.expand_or_jump() end<CR>',
          "LuaSnip complete",
        },
      }, { noremap = true, mode = "i" })
    end,
  },
}
