vim.keymap.set("n", "<leader>cs", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", ":write<CR>", { silent = true })
vim.keymap.set({"n", "v", "i"}, "<S-ScrollWheelUp>", "z<Left>7")
vim.keymap.set({"n", "v", "i"}, "<S-ScrollWheelDown>", "z<Right>7")
