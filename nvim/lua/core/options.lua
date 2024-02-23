vim.g.mapleader = " "

local opt = vim.opt

-- opt.autowrite = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.number = true
-- opt.relativenumber = true
opt.list = true
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.wrap = false
opt.sidescroll = 1
opt.sidescrolloff = 7

local function escape(str)
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end

local en = [[abcdefghijklmnopqrstuvwxyz,.;'[]`/]]
local ua = [[фисвуапршолдьтщзйкіегмцчнябюжєхї'.]]
local en_shift = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>:"{}~?]]
local ua_shift = [[ФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯБЮЖЄХЇʼ,]]
vim.opt.langmap = vim.fn.join({ escape(ua_shift) .. ";" .. escape(en_shift), escape(ua) .. ";" .. escape(en) }, ",")
