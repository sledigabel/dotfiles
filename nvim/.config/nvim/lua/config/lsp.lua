local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = vim.tbl_extend("keep", capabilities, {
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
    didChangeConfiguration = {
      dynamicRegistration = true,
    },
  },
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
    diagnostics = {
      dynamicRegistration = true,
      relatedDocumentSupport = true,
    },
  },
})
capabilities =
  vim.tbl_extend("keep", capabilities, { workspace = { didChangeConfiguration = { dynamicRegistration = true } } })

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.enable("pylsp")
vim.lsp.enable("jsonls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gradle_ls")
vim.lsp.enable("yamlls")

-- for swift
vim.lsp.enable("sourcekit")

vim.lsp.enable("markdown_oxide")
vim.lsp.enable("marksman")
vim.lsp.enable("buf_ls")
vim.lsp.enable("bashls")

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      -- [vim.diagnostics.severity.ERROR] =  " ",
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  -- virtual_text = {
  --   prefix = "●", -- Could be '●', '▎', 'x', '■'
  -- },
})

-- Formatting helpers
local function buf_lsp_filter_function(client)
  -- return client.name ~= "pylsp"
  return true
end

local function do_format()
  vim.lsp.buf.format({ async = true, filter = buf_lsp_filter_function })
end

-- sonarqube - might not work
-- local sonarhome = os.getenv("HOME") .. "/dev/tools/sonarlint/latest/extension/"
-- require("sonarlint").setup({
--   server = {
--     cmd = {
--       "java",
--       "-jar",
--       sonarhome .. "server/sonarlint-ls.jar",
--       -- Ensure that sonarlint-language-server uses stdio channel
--       "-stdio",
--       "-analyzers",
--       sonarhome .. "analyzers/sonargo.jar",
--       sonarhome .. "analyzers/sonarhtml.jar",
--       sonarhome .. "analyzers/iac.jar",
--       sonarhome .. "analyzers/java.jar",
--       sonarhome .. "analyzers/javasymbolicexecution.jar",
--       sonarhome .. "analyzers/sonarjs.jar",
--       sonarhome .. "analyzers/sonarphp.jar",
--       sonarhome .. "analyzers/sonartext.jar",
--     },
--     settings = {
--       sonarlint = {
--         connectedMode = {
--           connections = {
--             sonarcloud = {
--               {
--                 organizationKey = "skyscanner",
--                 connectionId = "skyscanner_sebastienledigabel",
--               },
--             },
--           },
--         },
--       },
--     },
--   },
--   filetypes = {
--     -- Tested and working
--     "python",
--     "cpp",
--     "java",
--     "go",
--     "javascript",
--     "html",
--     "php",
--   },
-- })

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
    -- { "<leader>gc", "<cmd>CodeCompleteToggle<cr>", desc = "", remap = false },

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
