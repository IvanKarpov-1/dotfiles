return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        local neogen = require("neogen")

        neogen.setup({
            snippet_engine = "luasnip",
        })

        vim.keymap.set("n", "<leader>nf", neogen.generate, { desc = "Generate anotations" })
    end,
}
