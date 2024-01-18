return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local catppuccin = require("catppuccin")

        catppuccin.setup({
            flavour = "frappe",
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
            }
        })

        vim.cmd.colorscheme("catppuccin")
    end,
}
