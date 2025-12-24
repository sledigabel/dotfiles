local M = {}

local lsp_executables = {
  { name = "pylsp", desc = "Python Language Server" },
  { name = "vscode-json-language-server", desc = "JSON Language Server" },
  { name = "lua-language-server", desc = "Lua Language Server" },
  { name = "gradle-language-server", desc = "Gradle Language Server" },
  { name = "yaml-language-server", desc = "YAML Language Server" },
  { name = "sourcekit-lsp", desc = "Swift/C/C++/ObjC Language Server" },
  { name = "markdown-oxide", desc = "Markdown Oxide LSP" },
  { name = "marksman", desc = "Marksman Markdown LSP" },
  { name = "bufls", desc = "Buf Protocol Buffers LSP" },
  { name = "bash-language-server", desc = "Bash Language Server" },
}

local formatters = {
  { name = "stylua", desc = "Lua formatter" },
  { name = "black", desc = "Python formatter" },
  { name = "isort", desc = "Python import sorter" },
  { name = "gofmt", desc = "Go formatter" },
  { name = "goimports", desc = "Go import formatter" },
  { name = "google-java-format", desc = "Java formatter" },
  { name = "prettier", desc = "JS/TS/JSON/YAML formatter" },
  { name = "shfmt", desc = "Shell script formatter" },
}

function M.check()
  vim.health.start("LSP Servers")
  
  local found_count = 0
  for _, lsp in ipairs(lsp_executables) do
    if vim.fn.executable(lsp.name) == 1 then
      vim.health.ok(string.format("%s (%s)", lsp.desc, lsp.name))
      found_count = found_count + 1
    else
      vim.health.warn(string.format("%s not found: %s", lsp.desc, lsp.name))
    end
  end
  
  vim.health.info(string.format("Found %d/%d LSP servers", found_count, #lsp_executables))
  
  vim.health.start("Formatters & Linters")
  
  found_count = 0
  for _, tool in ipairs(formatters) do
    if vim.fn.executable(tool.name) == 1 then
      vim.health.ok(string.format("%s (%s)", tool.desc, tool.name))
      found_count = found_count + 1
    else
      vim.health.info(string.format("%s not found: %s (optional)", tool.desc, tool.name))
    end
  end
  
  vim.health.info(string.format("Found %d/%d formatters", found_count, #formatters))
end

return M
