return {
	"gorbit99/codewindow.nvim",
    keys = {
        {
            "<leader>mm",
            function()
                require("codewindow").toggle_minimap()
            end,
        },
        {
            "<leader>mf",
            function()
                require("codewindow").toggle_focus()
            end
        }
    },
    opts = {
        max_minimap_height = 30,
        show_cursor = false,
        screen_bounds = "background",
        window_border = "single",
        relative = "editor",
    }
}
