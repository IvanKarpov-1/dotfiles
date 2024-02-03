return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",
            "chrisgrieser/cmp_yanky",
            {
                "tzachar/cmp-fuzzy-path",
                dependencies = {
                    {
                        "tzachar/fuzzy.nvim",
                        dependencies = {
                            "nvim-telescope/telescope-fzf-native.nvim",
                            build = "make",
                        },
                    },
                },
            },
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    -- { name = "cmp_yanky" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                    { name = "fuzzy_path" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                preselect = "none",
                sources = {
                    { name = "buffer" },
                },
                experimental = {
                    ghost_text = true,
                    native_menu = false,
                },
            })

            cmp.setup.cmdline(":", {
                preselect = "none",
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "fuzzy_path" },
                }, {
                    { name = "cmdline" },
                    { name = "cmdline_history" },
                }),
                experimental = {
                    ghost_text = true,
                    native_menu = false,
                },
            })
        end,
    },
}
