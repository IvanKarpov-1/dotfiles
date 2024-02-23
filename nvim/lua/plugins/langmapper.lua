return {
    "Wansmer/langmapper.nvim",
    lazy = false,
    priority = 1,
    config = function()
        local langmapper = require("langmapper")

        langmapper.setup({
            hack_keymap = false,
            layouts = {
                ua = {
                    id = "ua",
                    layout = "ФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯБЮЖЄХЇʼ,фисвуапршолдьтщзйкіегмцчнябюжєхї'.",
                    default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>:"{}~?abcdefghijklmnopqrstuvwxyz,.;'[]`/]],
                }
            },
            os = {
                Linux = {
                    get_current_layout_id = function()
                        local cmd = "gsettings"
                        if vim.fn.executable(cmd) then
                            local output = vim.fn.system(
                                cmd .. " get org.gnome.desktop.input-sources mru-sources | sed -r \"s/\\S*\\s'([^']+).*/\\1/\""
                            )
                            return output
                        end
                    end,
                },
            },
        })

        langmapper.hack_get_keymap()
    end,
}
