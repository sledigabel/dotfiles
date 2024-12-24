local nvim_lsp = require("lspconfig")
local util = require("lspconfig.util")

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = vim.tbl_extend(
  "keep",
  capabilities,
  { textDocument = { completion = { completionItem = { snippetSupport = true } } } }
)
capabilities =
  vim.tbl_extend("keep", capabilities, { workspace = { didChangeConfiguration = { dynamicRegistration = true } } })

-- python
nvim_lsp.pylsp.setup({
  capabilities = capabilities,
  settings = {
    pylsp = {
      configurationSources = { "black" },
      plugins = {
        flake8 = {
          enabled = false,
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

-- for swift
nvim_lsp.sourcekit.setup({
  capabilities = capabilities,
})

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

local servers = { "rust_analyzer", "bashls", "buf_ls" }
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

vim.diagnostic.config({
  virtual_text = false,
  -- virtual_text = {
  --   prefix = "●", -- Could be '●', '▎', 'x', '■'
  -- },
})

-- Formatting helpers
local function buf_lsp_filter_function(client)
  return client.name ~= "pylsp"
end

local function do_format()
  vim.lsp.buf.format({ async = true, filter = buf_lsp_filter_function })
end

-- [ key bindings ]
local wk = require("which-key")
wk.add({
  mode = "n",
  {
    { "<leader>g", group = "Lsp", remap = false },

    { "<leader>gD", "<cmd>Lspsaga finder<cr>", desc = "Saga Finder", remap = false },
    { "<leader>gO", "<cmd>Lspsaga outline<cr>", desc = "Saga Outline", remap = false },
    { "<leader>ga", "<cmd>Lspsaga code_action<cr>", desc = "CodeActions", remap = false },
    { "<leader>gd", vim.lsp.buf.definition, desc = "Definition", remap = false },
    { "gd", vim.lsp.buf.declaration, desc = "Declaration", remap = false },
    { "<leader>ge", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics", remap = false },
    { "<leader>gi", vim.lsp.buf.implementation, desc = "Implementations", remap = false },
    { "<leader>gt", vim.lsp.buf.type_definition, desc = "Type definition", remap = false },
    { "<leader>gr", vim.lsp.buf.references, desc = "References", remap = false },

    -- Copilot
    { "<leader>gc", "<cmd>CodeCompleteToggle<cr>", desc = "", remap = false },

    -- Helpers
    { "<leader>go", "<cmd>lua io.popen('gh pr view -w')<cr>", desc = "Open PR in web", remap = false },

    -- Rename
    { "<leader>rN", "<cmd>Lspsaga rename ++project<cr>", desc = "Rename", remap = false },
    { "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "Rename", remap = false },

    -- format
    { "<leader>lf", do_format, desc = "Formatting", remap = false },

    { "L", "<Cmd>Lspsaga peek_definition<cr>", desc = "Peek definition", remap = false },
    { "[g", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev diag", remap = false },
    { "]g", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next diag", remap = false },
  },
})

wk.add({
  mode = "v",
  -- range formatting
  {
    "<leader>lf",
    "<Esc><cmd>lua vim.lsp.buf.range_formatting()<cr>gv",
    desc = "Format selection",
    remap = false,
  },
})
