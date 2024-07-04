return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.builtins.diagnostics.write_good.filetypes = { "markdown", "markdown_obsidian" }

      local sources = {
        -- null_ls.builtins.diagnostics.luacheck,
        -- null_ls.builtins.diagnostics.pylint,
        -- null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.google_java_format,
        null_ls.builtins.formatting.isort,
        -- null_ls.builtins.formatting.autoflake,
        -- null_ls.builtins.formatting.lua_format,
        -- null_ls.builtins.code_actions.eslint,
        -- null_ls.builtins.code_actions.gitsigns,
        -- null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.alex,
        null_ls.builtins.diagnostics.ansiblelint,
        null_ls.builtins.diagnostics.buf,
        null_ls.builtins.diagnostics.cfn_lint,
        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.commitlint,
        null_ls.builtins.diagnostics.cppcheck,
        -- null_ls.builtins.diagnostics.eslint,
        -- null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.golangci_lint,
        -- null_ls.builtins.diagnostics.jsonlint,
        -- null_ls.builtins.diagnostics.markdownlint,
        -- null_ls.builtins.diagnostics.semgrep,
        -- null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.staticcheck,
        null_ls.builtins.diagnostics.write_good,
        -- null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.buf,
        null_ls.builtins.formatting.cmake_format,
        -- null_ls.builtins.formatting.eslint,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        -- null_ls.builtins.formatting.json_tool,
        -- null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.remark,
        -- null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.sqlformat,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.terraform_fmt,
      }

      null_ls.setup({ sources = sources })
    end,
  },
}
