vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.formatoptions = "cqrn1"
vim.o.number = true
vim.o.numberwidth = 4
vim.o.paste = false
-- vim.o.relativenumber = true  -- not sure i need this now
vim.o.scrolloff = 5
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.swapfile = true
vim.o.signcolumn = "yes"
vim.cmd([[
  set conceallevel=1
]])

-- search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.inccommand = "split"
vim.o.smartcase = true

-- autoindent
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.shiftround = false

-- stop removing the new line at the end of files!
vim.o.eol = true
vim.o.fixeol = false
-- aesthetics
vim.o.list = true
vim.o.listchars = "nbsp:+,space:⋅,tab:󰇘 ,trail:-"

-- mouse
vim.o.mouse = "a"

-- directory settings
vim.o.directory = os.getenv("HOME") .. "/.vim/tmp/"

-- undo
vim.o.undofile = true

-- updating
vim.o.updatetime = 250

-- highlight the yanking
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}]])

vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.termguicolors = true

-- statusline
vim.opt.laststatus = 3

-- [ for obsidian ]
local obsidianre = "iCloud~md~obsidian"

local obsidian_group = vim.api.nvim_create_augroup("Obsidian", { clear = true })

vim.api.nvim_create_autocmd({
  "BufNewFile",
  "BufRead",
}, {
  pattern = "*.md",
  group = obsidian_group,
  callback = function(ev)
    -- extract the dirname
    local dirname = vim.fn.fnamemodify(ev.file, ":h")
    local lookup = string.find(dirname, obsidianre, 1, true)
    if lookup ~= nil then
      vim.api.nvim_buf_set_option(ev.buf, "filetype", "markdown_obsidian")
      vim.treesitter.start(0, "markdown")
      vim.o.autoread = true
      local map = vim.keymap.set
      map("i", "<C-P>", "<esc><esc>:ObsidianPasteImg<cr>GA", { buffer = true, remap = false })
      map("n", "<C-P>", ":ObsidianPasteImg<cr>", { buffer = true, remap = false })
    end
  end,
})

vim.cmd([[
augroup JsonnetFiles
  autocmd!
  autocmd BufReadPre *.jsonnet setfiletype jsonnet
  autocmd BufReadPre *.libsonnet setfiletype jsonnet
augroup END
]])

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- [ Tree sitter ] --
  {
    "nvim-treesitter/nvim-treesitter",
    build = { ":TSUpdate" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)
        auto_install = true,
        ignore_install = {}, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },

          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["[c"] = "@class.outer",
              ["[f"] = "@function.outer",
            },
            goto_previous_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- [ Surround! ]
  {
    "ur4ltz/surround.nvim",
    event = "InsertEnter",
    config = function()
      require("surround").setup({ mappings_style = "surround", map_insert_mode = false })
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = false,
          registers = false,
        },
        -- window = {
        --   border = "double",
        -- },
      })

      local function run_local_test()
        local ft = vim.bo.filetype
        if ft == "go" then
          return vim.cmd([[ GoTestFunc ]])
        elseif ft == "python" then
          return require("dap-python").test_method()
        else
          return print("Filetype not supported for unit test")
        end
      end

      local function terminate()
        local ft = vim.bo.filetype
        if ft == "go" then
          return vim.cmd([[ GoDebug --stop]])
        else
          return vim.cmd([[ DapTerminate ]])
        end
      end

      local function close_all_windows()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local config = vim.api.nvim_win_get_config(win)
          if config.relative ~= "" then
            vim.api.nvim_win_close(win, false)
          end
        end
      end

      -- Leader key normal mode
      wk.add({
        mode = "n",
        -- Utils
        { "<leader>/", "<cmd>normal yyPgccj<cr>", desc = "Copy and comment", remap = false },
        { "<leader>caw", close_all_windows, desc = "Close all windows", remap = false },
        { "<leader>y", '"*y', desc = "Copy to the clipboard", remap = false },
        { "<C-d>", "<C-d>zz", desc = "scroll down", remap = false },
        { "<C-s>", ":w<cr>", desc = "save", remap = false },
        { "<C-u>", "<C-u>zz", desc = "scroll up", remap = false },
        { "[[", "<cmd>Gitsigns prev_hunk<cr>", desc = "[Git] next hunk", remap = false },
        { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer", remap = false },
        { "]]", "<cmd>Gitsigns next_hunk<cr>", desc = "[Git] previous hunk", remap = false },
        { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer", remap = false },

        { "<leader>d", "<cmd>bd<cr>", desc = "Delete buffer", remap = false },
        --
        -- Debugging
        -- { "<leader>B", group = "debugger", remap = false },
        -- { "<leader>BB", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Breakpoint", remap = false },
        -- { "<leader>BO", require("dap").step_out, desc = "Step Out", remap = false },
        -- { "<leader>Bb", require("dap").toggle_breakpoint, desc = "Breakpoint", remap = false },
        -- { "<leader>Bc", require("dap").continue, desc = "Continue", remap = false },
        -- { "<leader>Bi", require("dap").step_into, desc = "Step Into", remap = false },
        -- { "<leader>Bo", require("dap").step_over, desc = "Step Over", remap = false },
        -- { "<leader>Bt", "<cmd>Telescope dap commands<cr>", desc = "Commands", remap = false },
        -- { "<leader>Bu", require("dapui").toggle, desc = "UI Toggle", remap = false },
        -- { "<leader>td", "<cmd>DapUiToggle<cr>", desc = "Toggle DAP UI", remap = false },
        -- {
        --   "<leader>BS",
        --   terminate,
        --   group = "debugger",
        --   desc = "Terminate",
        --   remap = false,
        -- },
        -- { "<leader>Bp", run_local_test, group = "debugger", desc = "(Debug) Run test", remap = false },

        -- Scratch
        { "<leader>sn", "<cmd>ScratchWithName<cr>", desc = "New Scratch", remap = false },
        { "<leader>so", "<cmd>ScratchOpenFzf<cr>", desc = "Open Scratch", remap = false },
        { "<leader>ss", "<cmd>Scratch<cr>", desc = "Open New Daily Scratch", remap = false },

        -- Neoclip
        { "<leader>p", group = "Neoclip", remap = false },
        { "<leader>pp", "<cmd>Telescope neoclip<cr>", desc = "Neoclip", remap = false },
      })

      wk.add({
        mode = { "v" },
        { "<", "<lt>gv", desc = "Tab in", remap = false },
        { ">", ">gv", desc = "Tab out", remap = false },
        { "J", ":m '>+1<CR>gv=gv", desc = "Moves selection one line down", remap = false },
        { "K", ":m '<-2<CR>gv=gv", desc = "Moves the selection one line up", remap = false },
        { "<leader>/", "ygv", desc = "Copy and comment", remap = false },
        { "<leader>y", '"*y', desc = "Copy to clipboard", remap = false },
      })

      wk.add({
        mode = { "i" },
        {
          "<C-Space>",
          '<cmd>lua ls = require("luasnip"); if ls.expand_or_jumpable() then ls.expand_or_jump() end<CR>',
          desc = "LuaSnip complete",
          remap = false,
        },
        { "<C-a>", "<esc>I", desc = "Get back to the beginning of the line", remap = false },
        { "<C-e>", "<esc>A", desc = "Skips to the end of the line", remap = false },
        { "<C-s>", "<esc>:w<cr>", desc = "save", remap = false },
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      local catppuccin = require("catppuccin")
      catppuccin.setup({
        transparent_background = true,
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
          },
          cmp = true,
          lsp_saga = true,
          gitsigns = true,
          telescope = true,
          nvimtree = {
            enabled = true,
            show_root = true,
          },
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
          which_key = true,
          markdown = true,
        },
        custom_highlights = function(colors)
          return {
            Whitespace = { fg = "#3B3B3B" },
          }
        end,
      })
      -- vim.g.catppuccin_flavour = "macchiato"
      -- vim.g.catppuccin_flavour = "moccha"
      vim.g.catppuccin_flavour = "frappe"

      vim.cmd([[ colorscheme catppuccin ]])
    end,
    enabled = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },

    config = function()
      require("config.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-github.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("gh")
    end,
  },

  -- [ tmux ] --
  {
    "aserowy/tmux.nvim",
    config = function()
      require("tmux").setup({
        copy_sync = {
          enable = false,
          redirect_to_clipboard = false,
          sync_clipboard = false,
          sync_unnamed = false,
        },
        navigation = {
          -- enables default keybindings (C-hjkl) for normal mode
          enable_default_keybindings = true,
        },
        resize = {
          -- enables default keybindings (A-hjkl) for normal mode
          enable_default_keybindings = true,
        },
      })
    end,
  },

  -- [ LSP ] --
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    -- dependencies = { "b0o/SchemaStore.nvim", "hrsh7th/cmp-nvim-lsp", "folke/neodev.nvim" },
    dependencies = { "b0o/SchemaStore.nvim", "folke/neodev.nvim" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      local lspsaga = require("lspsaga")
      lspsaga.setup({
        lightbulb = {
          enable = false,
        },
        diagnostics = {
          keys = {
            quit = "<Esc>",
          },
        },
        code_action = {
          keys = {
            quit = "<Esc>",
          },
        },
        finder = {
          keys = {
            toggle_or_open = "<CR>",
            quit = "<Esc>",
          },
        },
        definition = {
          keys = {
            toggle_or_open = "<CR>",
            quit = "<Esc>",
          },
        },
        rename = {
          keys = {
            quit = "<Esc>",
          },
        },
      })
    end,
  },
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  -- travelapi
  {
    dir = "/Users/sebastienledigabel/dev/work/nvim-travelapi/",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "lewis6991/hover.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("config.hover")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("config.null-ls")
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        override_vim_notify = true,
      },
    },
  },

  -- [ CMP ]
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "windwp/nvim-autopairs",
      "onsails/lspkind-nvim",
      "petertriho/cmp-git",
      "cmp_obsidian_users",
    },
    config = function()
      require("config.cmp")
    end,
  },
  -- this is the cmp module to complete usernames
  {
    {
      name = "cmp_obsidian_users",
      dir = "/Users/sebastienledigabel/dev/work/cmp-obsidian-users/",
      lazy = true,
    },
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    -- event = "InsertEnter",
    config = function()
      -- require('Luasnip').setup({})
      require("luasnip/loaders/from_vscode").lazy_load({
        paths = { "./friendly-snippets" },
      })

      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets("markdown_obsidian", {
        s("todo", {
          t("- [ ] "),
          i(1, "content"),
        }),
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      check_ts = true,
      ts_config = {
        -- lua = { "string" }, -- it will not add a pair on that treesitter node
        -- javascript = { "template_string" },
        -- java = false, -- don't check treesitter on java
      },
    },
    event = "InsertEnter",
  },

  -- [ GIT ]
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 2000,
        },
      })
    end,
    event = "BufRead",
  },
  {
    "ruifm/gitlinker.nvim",
    lazy = true,
    event = "BufReadPre",
    config = function()
      require("gitlinker").setup({
        opts = {
          action_callback = require("gitlinker.actions").copy_to_clipboard,
          print_url = false,
        },
        callbacks = {
          ["github.skyscannertools.net"] = require("gitlinker.hosts").get_github_type_url,
        },
      })
    end,
  },

  -- [ notify ]
  -- {
  --   "rcarriga/nvim-notify",
  --   -- dependencies = { "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("notify").setup({
  --       background_colour = "#000000",
  --       timeout = 500,
  --       top_down = false,
  --       render = "compact",
  --     })
  --
  --     vim.notify = require("notify")
  --   end,
  -- },

  -- [ Nvim tree ]
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icon
      "folke/which-key.nvim",
    },
    config = function()
      require("nvim-tree").setup({
        hijack_cursor = true,
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        filters = {
          -- git_ignored = true,
          custom = { "node_modules", ".idea", "^.git$" },
        },
        view = {
          adaptive_size = true,
          preserve_window_proportions = true,
        },
        renderer = {
          indent_markers = {
            enable = false,
          },
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })

      local wk = require("which-key")
      wk.add({
        mode = "n",
        { "<leader>t", group = "NvimTree", remap = false },
      })
    end,
    lazy = true,
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFindFileToggle" },
    keys = {
      { "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree", remap = false },
      { "<leader>gf", "<cmd>NvimTreeFindFile<cr>", desc = "Find file", remap = false },
    },
  },

  -- [ lua line ]
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      require("config.status")
    end,
    event = "BufRead",
  },
  {
    "linrongbin16/lsp-progress.nvim",
    lazy = true,
    config = function()
      local api = require("lsp-progress.api")
      require("lsp-progress").setup({
        format = function(client_messages)
          if #client_messages > 0 then
            return table.concat(client_messages, " ")
          end
          if #api.lsp_clients() > 0 then
            return ""
          end
          return ""
        end,
      })
    end,
  },

  -- [ Copilot ]
  {
    "zbirenbaum/copilot.lua",
    cmd = { "CodeCompleteToggle", "Copilot" },
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<C-x><C-x>",
            accept_word = false,
            accept_line = false,
            next = "<C-x>l",
            prev = "<C-x>h",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          gitcommit = false,
          gitrebase = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })

      function ToggleCopilot()
        if vim.g.copilot_enabled == nil then
          vim.g.copilot_enabled = true
          vim.cmd("Copilot enable")
          return
        end

        if vim.g.copilot_enabled == true then
          vim.cmd("Copilot disable")
        else
          vim.cmd("Copilot enable")
        end

        vim.g.copilot_enabled = not vim.g.copilot_enabled
      end

      vim.api.nvim_create_user_command("CodeCompleteToggle", ToggleCopilot, {})
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- branch = "canary",
    branch = "main",
    dependencies = {
      -- { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function()
      require("CopilotChat").setup({})
    end,
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatDebugInfo",
      "CopilotChatModels",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
    },
    keys = {
      {
        "<leader>cc",
        function()
          -- if filetype is commit, open the copilot with CommitStaged
          if vim.bo.filetype == "gitcommit" then
            vim.cmd("CopilotChatCommit")
          else
            vim.cmd("CopilotChat")
          end
        end,
        desc = "Open Copilot Chat",
        remap = false,
      },
      { "<leader>cc", "<cmd>CopilotChat<cr>", mode = "v", desc = "Open Copilot Chat", remap = false },
    },
  },

  -- [ Obsidian ]
  {
    "epwalsh/obsidian.nvim",
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianToday",
      "ObsidianTomorrow",
      "ObsidianSearch",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter",
      "folke/which-key.nvim",
    },
    config = function()
      require("config.obsidian")
    end,
  },

  -- [ Go ]
  {
    "ray-x/go.nvim",
    ft = { "go" },
    config = function()
      local on_attach_normal = function(client, bufnr)
        vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(vim.lsp.handlers.hover, { border = "single", focusable = false })
        vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.hover, { border = "single", focusable = false })
      end

      require("go").setup({
        gofmt = "gofumpt",
        comment_placeholder = "   ",
        lsp_keymaps = false, -- false: don't reassign all default keymaps, keep your ones
        lsp_cfg = true, -- false: use your own lspconfig
        lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
        lsp_codelens = true,
        lsp_on_attach = on_attach_normal, -- use on_attach from go.nvim
        dap_debug = true,
        icons = false,
        lsp_inlay_hints = {
          enabled = false,
        },
      })

      vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
    end,
  },

  -- [ java ]
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
    -- lazy = false,
    ft = "java",
  },

  -- [ fun ]
  {
    "eandrju/cellular-automaton.nvim",
    lazy = true,
    cmd = {
      "CellularAutomaton",
    },
  },
})
