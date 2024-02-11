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
                    -- lua
                    formatting.stylua,
                    -- ts, js
                    diagnostics.eslint_d,
                    -- web
                    formatting.prettier,
                    -- yaml
                    diagnostics.yamllint,
                    -- gitsigns
                    code_actions.gitsigns,
                    -- shell
                    diagnostics.shellcheck,
                    formatting.beautysh,
                    -- markdown
                    diagnostics.markdownlint,
                    diagnostics.vale,
                    -- python
                    diagnostics.mypy.with({
                        extra_args = function()
                            local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
                            return { "--python-executable", virtual .. "/bin/python3" }
                        end,
                    }),
                    diagnostics.ruff,
                    formatting.black,
                    -- c/c++
                    formatting.clang_format,
                    diagnostics.cpplint.with({
                        args = function()
                            return { "--filter=-legal/copyright", "$FILENAME" }
                        end,
                    }),
                },
            })

            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer using attached LSP" })
        end,
    },
}
