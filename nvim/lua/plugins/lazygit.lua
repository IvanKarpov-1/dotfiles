return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader>lg",
            ":LazyGit<CR>",
            desc = "Open LazyGit",
        },
    },
}
