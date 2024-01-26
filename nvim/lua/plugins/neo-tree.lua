return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local neo_tree = require("neo-tree")
        neo_tree.setup({
            filesystem = {
                window = {
                    mappings = {
                        ["o"] = "system_open",
                    },
                },
            },
            commands = {
                system_open = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                end,
            },
        })

        vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { silent = true, desc = "Open neotree" })
        vim.keymap.set("n", "<M-n>", ":Neotree toggle<CR>", { silent = true, desc = "Toggle neotree" })
    end,
}
