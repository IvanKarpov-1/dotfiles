-- Copy buffer or selection as RTF
vim.api.nvim_create_user_command("RichTextCopy", function(args)
    local saved_html_use_css = vim.g.html_use_css
    local saved_html_no_progress = vim.g.html_no_progress
    vim.g.html_use_css = false
    vim.g.html_no_progress = true
    vim.cmd({
        cmd = "TOhtml",
        range = { args.line1, args.line2 },
    })
    vim.g.html_use_css = saved_html_use_css
    vim.g.html_no_progress = saved_html_no_progress

    vim.cmd("w !xclip -selection clipboard -t text/html -i")
    vim.cmd.bwipeout({ bang = true })
end, {
    range = "%",
})
