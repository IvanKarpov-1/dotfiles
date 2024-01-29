return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "md" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    keys = {
        {
            mode = "n",
            "<leader>mpt",
            ":MarkdownPreviewToggle<CR>",
            silent = true,
            desc = "Toggle markdown preview",
        },
        {
            mode = "n",
            "<leader>mps",
            ":MarkdownPreviewStop<CR>",
            silent = true,
            desc = "Stop markdown preview",
        },
    },
}
