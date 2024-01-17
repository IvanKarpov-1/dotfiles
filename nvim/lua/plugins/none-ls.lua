return {
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            automatic_installation = true,
        }
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local diagnostics = null_ls.builtins.diagnostics
            local formatting = null_ls.builtins.formatting
            local code_actions = null_ls.builtins.code_actions

            null_ls.setup({
                sources = {
                    formatting.stylua,

                    diagnostics.eslint_d,
                    formatting.prettier,

                    diagnostics.yamllint,

                    code_actions.gitsigns,
                },
            })

            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        end,
    },
}
