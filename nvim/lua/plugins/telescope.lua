return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sharkdp/fd",
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-P>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

            telescope.load_extension("ui-select")
            telescope.load_extension("noice")
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
}
