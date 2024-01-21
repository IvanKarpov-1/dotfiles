return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local bufferline = require("bufferline")

        bufferline.setup({
            options = {
                diagnostics = "nvim_lsp",
                middle_mouse_command = "bdelete! %d",
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

        vim.keymap.set("n", "<C-d>", ":bdelete!<CR>", {})
        vim.keymap.set("n", "<M-d>", ":bdelete! ", {})
        vim.keymap.set("n", "<leader>gb", ":BufferLineGoToBuffer ", {})
        vim.keymap.set("n", "<S-h>", ":BufferLineMovePrev<CR>", {})
        vim.keymap.set("n", "<S-l>", ":BufferLineMoveNext<CR>", {})
        vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<CR>", {})
        vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<CR>", {})
        vim.keymap.set("n", "<C-j>", ":lua require(\"bufferline\").go_to(1, true)<CR>", {})
        vim.keymap.set("n", "<C-k>", ":lua require(\"bufferline\").go_to(-1, true)<CR>", {})
    end,
}
