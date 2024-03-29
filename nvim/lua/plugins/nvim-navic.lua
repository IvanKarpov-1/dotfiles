return {
    "SmiteshP/nvim-navic",
    config = function()
        local navic = require("nvim-navic")

        navic.setup({
            icons = {
                File = " ",
                Module = " ",
                Namespace = " ",
                Package = " ",
                Class = " ",
                Method = " ",
                Property = " ",
                Field = " ",
                Constructor = " ",
                Enum = " ",
                Interface = " ",
                Function = " ",
                Variable = " ",
                Constant = " ",
                String = " ",
                Number = " ",
                Boolean = " ",
                Array = " ",
                Object = " ",
                Key = " ",
                Null = " ",
                EnumMember = " ",
                Struct = " ",
                Event = " ",
                Operator = " ",
                TypeParameter = " ",
            },
            lsp = {
                auto_attach = true,
                preference = nil,
            },
            -- depth_limit = 5,
            -- depth_limit_indicator = "..",
            -- separator = " > ",
            highlight = true,
            -- safe_output = false,
            click = true,
        })

        vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
}
