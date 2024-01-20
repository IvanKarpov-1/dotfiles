return {
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local catppuccin = require("catppuccin.utils.lualine")("macchiato")
            local cp = require("catppuccin.palettes").get_palette("macchiato")

            local normal_b = catppuccin.normal.b
            local normal_c = catppuccin.normal.c
            catppuccin.normal = {
                a = { bg = "#8bd5ca", fg = cp.mantle, gui = "bold" },
                b = normal_b,
                c = normal_c,
            }

            require("lualine").setup({
                options = {
                    theme = catppuccin,
                },
                sections = {
                    -- lualine_a = {
                    --     "buffers",
                    -- },
                    lualine_x = {
                        {
                            require("noice").api.status.command.get,
                            cond = require("noice").api.status.command.has,
                            color = { fg = "#8bd5ca" },
                        },
                        {
                            require("noice").api.statusline.mode.get,
                            cond = require("noice").api.statusline.mode.has,
                            color = { fg = "#8bd5ca" }
                        }
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
