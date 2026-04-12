--leader
vim.g.mapleader = " "
--netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--esc keymap
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("v", "gh", "<esc>")
vim.keymap.set("c", "jj", "<esc>")
--vertical movements
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--move highlighted lines
vim.keymap.set("v", "K", ":m -2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+<CR>gv=gv")
--skip one char
vim.keymap.set("i", "<A-space>", "<esc>1la")
--create splits
vim.keymap.set("n", "<leader>sv", "<cmd>vsp<cr>")
vim.keymap.set("n", "<leader>sh", "<cmd>sp<cr>")
--navigate windows
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")
--navigate and create tabs
vim.keymap.set("n", "<S-h>", "gT")
vim.keymap.set("n", "<S-l>", "gt")
vim.keymap.set("n", "<leader>tn", ":tabnew")
vim.keymap.set("n", "<leader>tm", ":tabmove")
--copy paste +clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
--add j k movements to jumpylist
vim.keymap.set( 'n', 'j', [[v:count ? (v:count >= 2 ? "m'" . v:count : '') . 'jzz' : 'jzz']], { noremap = true, expr = true })
vim.keymap.set( 'n', 'k', [[v:count ? (v:count >= 2 ? "m'" . v:count : '') . 'kzz' : 'kzz']], { noremap = true, expr = true })
--kesizing splits
vim.keymap.set("n", "+", "<cmd>vertical resize +5<CR>")
vim.keymap.set("n", "_", "<cmd>vertical resize -5<CR>")
vim.keymap.set("n", "<C-=>", "<cmd>resize -5<CR>")
vim.keymap.set("n", "<C-->", "<cmd>resize +5<CR>")
--zenmode
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")
