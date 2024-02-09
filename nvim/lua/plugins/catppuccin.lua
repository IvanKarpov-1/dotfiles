return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local catppuccin = require("catppuccin")

        catppuccin.setup({
            flavour = "macchiato",
            integrations = {
                cmp = true,
                gitsigns = true,
                treesitter = true,
                alpha = true,
                mason = true,
                mini = {
                    enable = true,
                    indentscope_color = "",
                },
                neotree = false,
                navic = {
                    enabled = true,
                    -- enabled = false,
                    custom_bg = "NONE",
                },
                ufo = true,
                rainbow_delimiters = true,
                telescope = {
                    enabled = true,
                },
                which_key = false,
            },
        })

        vim.cmd.colorscheme("catppuccin")
    end,
}
