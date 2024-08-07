return {
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = { "b0o/SchemaStore.nvim", "hrsh7th/cmp-nvim-lsp", "folke/neodev.nvim" },
    config = function()
      local nvim_lsp = require("lspconfig")
      local util = require("lspconfig.util")

      -- for python to use the pyenv lsp
      -- local pyenv_bin_path = os.getenv("PYENV_VIRTUAL_ENV")
      -- if pyenv_bin_path == nil then
      --   -- pyenv_bin_path = "/Users/sebastienledigabel/.pyenv/shims"
      -- else
      --   pyenv_bin_path = pyenv_bin_path .. "/bin"
      -- end

      local lsp_status = require("lsp-status")
      -- lsp_status.config({ show_filename = false, diagnostics = false, current_function = false })
      lsp_status.register_progress()

      local capabilities =
        vim.tbl_extend("keep", require("cmp_nvim_lsp").default_capabilities(), lsp_status.capabilities)
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
      -- vim.print(capabilities)

      -- python
      nvim_lsp.pylsp.setup({
        -- cmd = { pyenv_bin_path .. "/pylsp" },
        -- cmd = { "pylsp" },
        capabilities = capabilities,
        settings = {
          pylsp = {
            configurationSources = { "black" },
            plugins = {
              flake8 = {
                enabled = false,
                -- executable = pyenv_bin_path .. "/flake8",
              },
              black = { enabled = true, line_length = 120 },
              pycodestyle = {
                enabled = true,
                maxLineLength = 160,
              },
              yapf = { enabled = false },
              mccabe = { enabled = true },
              autopep8 = { enabled = false },
            },
          },
        },
      })

      -- json
      nvim_lsp.jsonls.setup({
        capabilities = capabilities,
        -- cmd = { "/Users/sebastienledigabel/node_modules/.bin/vscode-json-languageserver" },
        commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end,
          },
        },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- jsonnet
      nvim_lsp.jsonnet_ls.setup({
        capabilities = capabilities,
        cmd = { "/Users/sebastienledigabel/dev/go/bin/jsonnet-language-server" },
      })

      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      -- nvim_lsp.sumneko_lua.setup({
      nvim_lsp.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              -- Setup your lua path
              -- path = runtime_path,
            },
            format = {
              enable = false,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              -- disables the prompt
              checkThirdParty = false,
            },
          },
        },
      })

      nvim_lsp.gradle_ls.setup({
        capabilities = capabilities,
        cmd = {
          "/Users/sebastienledigabel/dev/perso/dotfiles/nvim/.config/nvim/java/vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server",
        },
        root_dir = util.root_pattern("settings.gradle", "build.gradle", "gradle.properties"),
      })

      nvim_lsp.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.yml",
              ["https://goreleaser.com/static/schema.json"] = "/.goreleaser.yml",
              ["https://json.schemastore.org/golangci-lint.json"] = {
                "/.golangci.yml",
                "/.golangci.yaml",
              },
              ["https://json.schemastore.org/chart.json"] = { "/Chart.yml", "/Chart.yaml" },
              -- ["kubernetes"] = "/*",
              ["/Users/sebastienledigabel/temp/catalog-schema.json"] = { "/.catalog.yml" },
            },
            hover = true,
            completion = true,

            customTags = {
              "!fn",
              "!And",
              "!And sequence",
              "!If",
              "!If sequence",
              "!Not",
              "!Not sequence",
              "!Equals",
              "!Equals sequence",
              "!Or",
              "!Or sequence",
              "!FindInMap",
              "!FindInMap sequence",
              "!Base64",
              "!Join",
              "!Join sequence",
              "!Cidr",
              "!Ref",
              "!Sub",
              "!Sub sequence",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!ImportValue sequence",
              "!Select",
              "!Select sequence",
              "!Split",
              "!Split sequence",
            },
          },
        },
      })

      -- local local_dir = os.getenv("TMUX_SESSION_DIR")
      -- if not local_dir then
      --   local_dir = vim.fn.getcwd()
      -- end
      --
      -- nvim_lsp.gopls.setup({
      -- 	capabilities = capabilities,
      -- })
      -- local servers = { 'gopls', 'rust_analyzer', 'bashls', 'yamlls', 'jsonnet_ls', 'sumneko_lua' }
      --

      nvim_lsp.markdown_oxide.setup({
        capabilities = capabilities,
        root_dir = function()
          return os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/"
        end,
        filetypes = { "markdown_obsidian" },
      })

      require("lspconfig").marksman.setup({
        capabilities = capabilities,
      })

      local servers = { "rust_analyzer", "bashls", "jsonnet_ls", "bufls" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup({
          capabilities = capabilities,
        })
      end

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        local hl2 = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl2, { text = icon, texthl = hl2, numhl = "" })
      end

      -- local M = {}
      --
      -- M.icons = {
      -- 	Class = " ",
      -- 	Color = " ",
      -- 	Constant = " ",
      -- 	Constructor = " ",
      -- 	Enum = "了 ",
      -- 	EnumMember = " ",
      -- 	Field = " ",
      -- 	File = " ",
      -- 	Folder = " ",
      -- 	Function = " ",
      -- 	Interface = "ﰮ ",
      -- 	Keyword = " ",
      -- 	Method = "ƒ ",
      -- 	Module = " ",
      -- 	Property = " ",
      -- 	Snippet = "﬌ ",
      -- 	Struct = " ",
      -- 	Text = " ",
      -- 	Unit = " ",
      -- 	Value = " ",
      -- 	Variable = " ",
      -- }

      -- function M.setup()
      --   local kinds = vim.lsp.protocol.CompletionItemKind
      --   for i, kind in ipairs(kinds) do
      --     kinds[i] = M.icons[kind] or kind
      --   end
      -- end

      vim.diagnostic.config({
        virtual_text = false,
        -- virtual_text = {
        --   prefix = "●", -- Could be '●', '▎', 'x', '■'
        -- },
      })

      -- WAIT UNTIL NEOVIM 0.10
      -- vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
      --   contents = vim.lsp.util._normalize_markdown(contents, {
      --     width = vim.lsp.util._make_floating_popup_size(contents, opts),
      --   })
      --
      --   vim.bo[bufnr].filetype = "markdown"
      --   vim.treesitter.start(bufnr)
      --   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
      --
      --   return contents
      -- end
      --
      -- Set for debugging
      -- vim.lsp.set_log_level("debug")
    end,
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        win = {
          type = "split",
          position = "bottom",
          size = 5,
        },
        modes = {
          diagnostics = {
            mode = "diagnostics", -- inherit from diagnostics mode
            filter = { buf = 0, ["not"] = {
              ft = "markdown_obsidian",
            } }, -- filter diagnostics to the current buffer
            pinned = true,
            auto_open = true,
            auto_close = true,
          },
        },
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      local lsp_signature = require("lsp_signature")
      lsp_signature.setup({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        -- handler_opts = {
        --   border = "rounded",
        -- },
        floating_window_above_cur_line = true,
      })
    end,
  },
  -- use({ "onsails/lspkind-nvim" })
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
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
        -- code_action_prompt = {
        -- 	enable = false,
        -- },
        -- finder_action_keys = {
        -- 	quit = "<Esc>",
        -- 	open = "<cr>",
        -- },
        -- code_action_keys = {
        -- 	quit = "<Esc>",
        -- },
        -- rename_action_keys = {
        -- 	quit = "<Esc>",
        -- },
      })
    end,
  },

  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  {
    "nvim-lua/lsp-status.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lsp-status").config({
        status_symbol = "",
        diagnostics = false,
        -- indicator_errors = " ",
        -- indicator_warnings = " ",
        -- indicator_info = " ",
        -- indicator_hint = " ",
        -- indicator_ok = "",
      })
    end,
  },
}
