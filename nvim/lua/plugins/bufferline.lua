return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "famiu/bufdelete.nvim",
    },
    config = function()
        local bufferline = require("bufferline")

        bufferline.setup({
            options = {
                diagnostics = "nvim_lsp",
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

        vim.keymap.set("n", "<C-d>", ":Bdelete!<CR>", { silent = true })
        vim.keymap.set("n", "<M-d>", ":Bdelete! ", { silent = true })
        vim.keymap.set("n", "<leader>gb", ":BufferLineGoToBuffer ", { silent = true })
        vim.keymap.set("n", "<S-h>", ":BufferLineMovePrev<CR>", { silent = true })
        vim.keymap.set("n", "<S-l>", ":BufferLineMoveNext<CR>", { silent = true })
        vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<CR>", { silent = true })
        vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<CR>", { silent = true })
        vim.keymap.set("n", "<C-j>", ":lua require(\"bufferline\").go_to(1, true)<CR>", { silent = true })
        vim.keymap.set("n", "<C-k>", ":lua require(\"bufferline\").go_to(-1, true)<CR>", { silent = true })
    end,
}
