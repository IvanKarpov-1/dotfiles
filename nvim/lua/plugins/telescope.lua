return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sharkdp/fd",
            "nvim-telescope/telescope-ui-select.nvim",
            "debugloop/telescope-undo.nvim",
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                    ["undo"] = {
                        side_by_side = true,
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.8,
                        },
                    },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-P>", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search for a string" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
            vim.keymap.set("n", "<leader>u", ":Telescope undo<CR>", { silent = true })

            telescope.load_extension("ui-select")
            telescope.load_extension("noice")
            telescope.load_extension("undo")
            telescope.load_extension("yank_history")
        end,
    },
}
