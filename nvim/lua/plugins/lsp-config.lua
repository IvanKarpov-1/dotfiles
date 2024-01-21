return {
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        event = "BufReadPre",
        opts = {
            automatic_installation = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities,
            })
            lspconfig.yamlls.setup({
                capabilities = capabilities,
            })
            lspconfig.bashls.setup({
                capabilities = capabilities,
            })
            lspconfig.html.setup({
                capabilities = capabilities,
            })
            lspconfig.omnisharp.setup({
                capabilities = capabilities,
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
    {
        "soulis-1256/hoverhints.nvim",
        init = function()
            vim.opt.mousemoveevent = true
        end,
        config = true,
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()

            vim.keymap.set("n", "<leader>rn", ":IncRename ")
            vim.keymap.set("n", "<leader>RN", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true })
        end,
    },
}
