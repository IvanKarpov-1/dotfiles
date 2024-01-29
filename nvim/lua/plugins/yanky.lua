return {
    "gbprod/yanky.nvim",
    opts = {
        system_clipboard = {
            sync_with_ring = false,
        }
    },
    keys = {
        {
            mode = "n",
            "<leader>p",
            function()
                require("telescope").extensions.yank_history.yank_history({})
            end,
            desc = "Open Yank history",
        },
        {
            mode = { "n", "x" },
            "y",
            "<Plug>(YankyYank)",
            desc = "Yank text",
        },
        {
            mode = { "n", "x" },
            "p",
            "<Plug>(YankyPutAfter)",
            desc = "Put yanked text after cursor",
        },
        {
            mode = { "n", "x" },
            "P",
            "<Plug>(YankyPutBefore)",
            desc = "Put yanked text before cursor",
        },
        {
            mode = "n",
            "<C-a>",
            "<Plug>(YankyPreviousEntry)",
            desc = "Select previous yank",
        },
        {
            mode = "n",
            "<C-s>",
            "<Plug>(YankyNextEntry)",
            desc = "Select next yank",
        },
    },
}
