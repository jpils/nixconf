vim.keymap.set("n", "<leader>on", function ()
	local noteName = vim.fn.input("Note Name > ")
	vim.cmd('ObsidianNew ' .. noteName)
end, {noremap = true, silent = true})

vim.keymap.set("n", "<leader>ot", function ()
	local templateName = vim.fn.input("Template Name > ")
	vim.cmd('ObsidianTemplate' .. noteName)
end, {noremap = true, silent = true})

vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLink<CR>", {noremap = true, silent = true})
