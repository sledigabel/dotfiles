-- return {}
return {
  {
    "Exafunction/codeium.vim",
    config = function()
      -- Codeium
      vim.g.codeium_enabled = false
      vim.g.codeium_no_map_tab = true

      -- function to check if Codeium is toggled
      function CheckCodeium()
        if vim.g.codeium_enabled == nil then
          return true
        end
        return vim.g.codeium_enabled
      end

      function ToggleCodeium()
        if CheckCodeium() then
          vim.g.codeium_enabled = false
        else
          vim.g.codeium_enabled = true
        end
      end

      function StatusCodeium()
        if CheckCodeium() then
          return " "
        else
          return "  "
        end
      end

      -- Command to toggle Codeium
      vim.api.nvim_create_user_command("CodeiumToggle", ToggleCodeium, {})

      -- change the codeium highlight group
      vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#656c79", italic = true })

      vim.cmd("imap <script><silent><nowait><expr> <C-x><C-x> codeium#Accept()")
    end,
  },
}
