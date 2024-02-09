return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")

            config.setup({
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
                indent = {
                    enable = true,
                    disable = { "html" },
                },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = "User",
        opts = {},
    },
}
