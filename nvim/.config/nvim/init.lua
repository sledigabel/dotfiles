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
          disable = function(_, bufnr)
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
            return file_size > 256 * 1024
          end,
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
  -- snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = false },
      input = { enabled = true },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "i" } },
            },
          },
        },
        sort = function(a, b)
          local upstream_sorter = require("snacks.picker").sort.default()

          local penalty = function(item)
            local label = (item.file or ""):lower()
            if label:find("test") == nil then
              return 1000
            end
            return nil
          end

          a.score_add = penalty(a)
          b.score_add = penalty(b)

          return upstream_sorter(a, b)
        end,
      },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>tt",
        "<cmd>lua require('snacks').explorer({ auto_close = true, })<cr>",
        desc = "Toggle explorer",
        remap = false,
      },
      { "<leader>gf", "<cmd>lua require('snacks').explorer.reveal()<cr>", desc = "Reveal file", remap = false },
      { "<leader>ff", "<cmd>lua require('snacks').picker.files()<cr>", desc = "Find file", remap = false },
      {
        "<leader>f.",
        "<cmd>lua require('snacks').picker.files({ cwd = vim.fn.stdpath('config'), ft = 'lua' })<cr>",
        desc = "Find Config File",
        remap = false,
      },
      { "<leader>b", "<cmd>lua require('snacks').picker.buffers()<cr>", desc = "Find buffer", remap = false },
      { "<leader>fa", "<cmd>lua require('snacks').picker.grep()<cr>", desc = "Grep files", remap = false },
      { "<c-p>", "<cmd>lua require('snacks').picker.git_files()<cr>", desc = "Git files", remap = false },
      { "<leader>gG", "<cmd>lua require('snacks').lazygit()<cr>", desc = "lazyGit", remap = false },
      -- Scratch
      { "<leader>sn", "<cmd>lua require('snacks').scratch()<cr>", desc = "New Scratch", remap = false },
      { "<leader>so", "<cmd>lua require('snacks').scratch.select()<cr>", desc = "Open Scratch", remap = false },
    },
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
      })

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
        -- { "<leader>Bp", run_local_test, group = "debugger", desc = "(Debug) Run test", remap = false },
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
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({

        theme = "ink",
      })
      vim.cmd("colorscheme kanso")
    end,
  },
  -- {
  --   "thesimonho/kanagawa-paper.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa-paper").setup({})
  --     vim.cmd("colorscheme kanagawa-paper-ink")
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({
  --       theme = "dragon",
  --     })
  --
  --     vim.cmd("colorscheme kanagawa")
  --   end,
  -- },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   config = function()
  --     local catppuccin = require("catppuccin")
  --     catppuccin.setup({
  --       transparent_background = true,
  --       integrations = {
  --         treesitter = true,
  --         native_lsp = {
  --           enabled = true,
  --         },
  --         cmp = true,
  --         lsp_saga = true,
  --         gitsigns = true,
  --         telescope = true,
  --         nvimtree = {
  --           enabled = false,
  --           show_root = true,
  --         },
  --         indent_blankline = {
  --           enabled = true,
  --           colored_indent_levels = true,
  --         },
  --         which_key = true,
  --         markdown = true,
  --       },
  --       custom_highlights = function(colors)
  --         return {
  --           Whitespace = { fg = "#3B3B3B" },
  --         }
  --       end,
  --     })
  --     -- vim.g.catppuccin_flavour = "macchiato"
  --     -- vim.g.catppuccin_flavour = "moccha"
  --     vim.g.catppuccin_flavour = "frappe"
  --
  --     vim.cmd([[ colorscheme catppuccin ]])
  --   end,
  --   enabled = true,
  -- },

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
    dependencies = { "b0o/SchemaStore.nvim" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
      })
      local lspsaga = require("lspsaga")
      lspsaga.setup({
        lightbulb = {
          enable = false,
          sign = true,
          virtual_text = false,
        },
        diagnostics = {
          -- let's try this diagnostic_only_current
          diagnostic_only_current = true,
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
    keys = {
      { "K", "<cmd>lua require('hover').hover()<cr>", desc = "Hover", mode = "n", remap = false },
    },
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

  -- sonarqube
  {
    dir = "/Users/sebastienledigabel/dev/perso/sonarlint.nvim",
    lazy = true,
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
      ft = "markdown_obsidian",
      dir = "/Users/sebastienledigabel/dev/work/cmp-obsidian-users/",
      -- lazy = true,
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

      -- for markdown code
      for _, value in pairs({ "markdown", "markdown_obsidian" }) do
        ls.add_snippets(value, {
          s("shell", {
            t({ "```sh", "" }),
            i(1, "script"),
            t({ "", "```", "", "" }),
          }),
        })
      end
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
    event = "VimEnter",
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
          markdown = true,
          yaml = true,
          codecompanion = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {
          -- trace = "verbose",
        },
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
    keys = {
      { "<leader>gc", "<cmd>CodeCompleteToggle<cr>", mode = "n", desc = "Toggle Copilot", remap = false },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      opts = {
        log_level = "TRACE",
      },
      strategies = {
        chat = {
          adapter = "copilot",
          opts = {
            register = "*",
          },
        },
        inline = { adapter = "copilot" },
      },
      display = {
        action_palette = {
          provider = "snacks",
        },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                -- get the list of models:
                -- lua =require("codecompanion.adapters.copilot").schema.model.choices()
                -- this only works after you've started a chat.
                -- default = "claude-3.7-sonnet",
                -- default = "o3-mini",
                -- default = "claude-3.7-sonnet",
                default = "gpt-4o"
              },
            },
          })
        end,
      },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    keys = {
      {
        "<leader>cc",
        function()
          -- if filetype is commit, open the copilot with CommitStaged
          if vim.bo.filetype == "gitcommit" then
            vim.cmd("CodeCompanion /commit")
          else
            vim.cmd("CodeCompanionChat toggle")
          end
        end,
        desc = "Open Copilot Chat",
        remap = false,
      },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = "v", desc = "Toggle Copilot Chat", remap = false },
      {
        "<leader>c?",
        function()
          local extended_model_list = require("codecompanion.adapters.copilot").schema.model.choices()
          local my_model_list = {}
          for k, v in pairs(extended_model_list) do
            vim.print(k, v)
            -- table.insert(my_model_list, value.name)
          end
          vim.print(my_model_list)
        end,
        mode = "n",
        desc = "List all models",
        remap = false,
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
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
      local on_attach_normal = function(_, _)
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
        dap_debug_keymap = false,
        dap_debug_gui = false,
        dap_debug_vt = { enabled = false },
        icons = false,
        lsp_inlay_hints = {
          enabled = false,
        },
      })

      vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
    end,
    dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
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

  -- [ DAP ]
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapShowLog",
      "DapContinue",
      "DapToggleBreakpoint",
      "DapClearBreakpoints",
      "DapToggleRepl",
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
      "DapTerminate",
      "DapDisconnect",
      "DapRestartFrame",
    },
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })
    end,
    keys = {
      { "<leader><leader>b", "<cmd>DapToggleBreakpoint<cr>", desc = "Breakpoint", remap = false },
      { "<leader><leader>l", "<cmd>DapStepOver<cr>", desc = "Step Over", remap = false },
      { "<leader><leader>j", "<cmd>DapStepInto<cr>", desc = "Step Into", remap = false },
      { "<leader><leader>k", "<cmd>DapStepOut<cr>", desc = "Step Out", remap = false },
      { "<leader><leader>c", "<cmd>DapContinue<cr>", desc = "Continue", remap = false },
      { "<leader><leader>s", "<cmd>DapDisconnect<cr>", desc = "Stop", remap = false },
      { "<leader><leader>C", "<cmd>DapClearBreakpoints<cr>", desc = "Clear all breakpoints", remap = false },
      { "<leader><leader>u", "<cmd>DapUiToggle<cr>", desc = "Toggle the Debug UI", remap = false },
    },
  },
  {
    "leoluz/nvim-dap-go",
    filetypes = { "go" },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dapgo = require("dap-go")
      dapgo.setup({
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
          {
            type = "go",
            name = "Debug (Build Flags & Arguments)",
            request = "launch",
            program = "${file}",
            args = require("dap-go").get_arguments,
            buildFlags = require("dap-go").get_build_flags,
          },
        },
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup({
        layouts = {
          {
            -- You can change the order of elements in the sidebar
            elements = {
              -- Provide IDs as strings or tables with "id" and "size" keys
              {
                id = "scopes",
                size = 0.25, -- Can be float or integer > 1
              },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
              { id = "repl", size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
          },
        },
      })
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end
    end,
  },

  -- for a smooth cursor
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   opts = {
  --     stiffness = 0.8, -- 0.6      [0, 1]
  --     trailing_stiffness = 0.5, -- 0.4      [0, 1]
  --     stiffness_insert_mode = 0.6, -- 0.4      [0, 1]
  --     trailing_stiffness_insert_mode = 0.6, -- 0.4      [0, 1]
  --     distance_stop_animating = 0.5, -- 0.1      > 0
  --   },
  -- },

  -- markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { "markdown" },
  },
})
