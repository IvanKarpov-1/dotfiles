return {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
        local silicon = require("silicon")
        silicon.setup({
            theme = "Catppuccin-macchiato",
            background = "#fff0",
            font = "RobotoMono Nerd Font Mono=13",
            pad_horiz = 0,
            pad_vert = 0,
            no_window_controls = true,
            line_offset = function(args)
                return args.line1
            end,
            shadow_blur_radius = 0,
            shadow_offset_x = 0,
            shadow_offset_y = 0,
            output = function()
                return "~/Картинки/silicon/" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
            end,
            to_clipboard = true,
        })
    end,
}
