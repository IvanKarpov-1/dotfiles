return {
    "akinsho/bufferline.nvim",
    version = "*",
    after = "catppuccin",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "famiu/bufdelete.nvim",
    },
    config = function()
        local bufferline = require("bufferline")

        bufferline.setup({
            options = {
                diagnostics = "nvim_lsp",
                highlights = require("catppuccin.groups.integrations.bufferline").get(),
                middle_mouse_command = "Bdelete! %d",
                right_mouse_command = "BufferLineTogglePin",
                numbers = function(opts)
                    return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
                end,
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or ""
                    return " " .. icon .. count
                end,
            },
        })

        vim.keymap.set("n", "<C-d>", ":Bdelete!<CR>", { silent = true, desc = "Delete current buffer" })
        vim.keymap.set("n", "<M-d>", ":Bdelete! ", { desc = "Delete buffer X" })
        vim.keymap.set("n", "<leader>gb", ":BufferLineGoToBuffer ", { silent = true, desc = "Go to buffer X" })
        vim.keymap.set("n", "<S-h>", ":BufferLineMovePrev<CR>", { silent = true, desc = "Move current buffer backward" })
        vim.keymap.set("n", "<S-l>", ":BufferLineMoveNext<CR>", { silent = true, desc = "Move current buffer forward"})
        vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Go to the previous buffer" })
        vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Go to the next buffer" })
        vim.keymap.set("n", "<C-j>", ":lua require(\"bufferline\").go_to(1, true)<CR>", { silent = true, desc = "Go to the first buffer" })
        vim.keymap.set("n", "<C-k>", ":lua require(\"bufferline\").go_to(-1, true)<CR>", { silent = true, desc = "Go to the last buffer" })
    end,
}
