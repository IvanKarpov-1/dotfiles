return {
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    icons_enabled = true,
                },
                sections = {
                    lualine_a = {
                        "buffers",
                    },
                },
                winbar = {
                    lualine_c = {
                        "navic",
                        color_correction = nil,
                        navic_opts = nil,
                    },
                },
                extensions = { "neo-tree" },
            })
        end,
    },
}
