return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")
        gitsigns.setup({
            signs = {
                add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
                change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
                delete = { hl = "GitSignsDelete", text = "x", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
                topdelete = { hl = "GitSignsDelete", text = "—", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
                changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn", },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "Git stage hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { silent = true, desc = "Git reset hunk" })
        vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git stage current buffer" })
        vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git reset current buffer" })
        vim.keymap.set("n", "<leader>ts", gitsigns.toggle_signs, { desc = "Toggle gitsigns signs" })
        vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle gitsigns deleted" })
        vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle gitsigns current line blame" })
    end,
}
