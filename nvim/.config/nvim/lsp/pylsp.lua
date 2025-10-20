return {
  cmd = { "pylsp" },
  filetypes = { "python" },
  settings = {
    pylsp = {
      plugins = {
        flake8 = { enabled = false },
        black = {
          enabled = true,
          line_length = 120,
          skip_magic_trailing_comma = true,
          skip_magic_string_normalization = true,
        },
        pycodestyle = { enabled = true, maxLineLength = 160 },
        yapf = { enabled = false },
        mccabe = { enabled = true },
        autopep8 = { enabled = false },
      },
    },
  },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
}
