-- override the <c-s> mapping to nothing so that
-- the CodeCompanion plugin doesn't write the content of
-- the buffer.
vim.keymap.set("n", "<c-s>", "<nop>", { buffer = true })
vim.keymap.set("n", "<leader>d", "<cmd>CodeCompanionChat Toggle<cr>", { buffer = true })

