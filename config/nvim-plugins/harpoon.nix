{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		harpoon2
	];

	lua = /* lua */ ''
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
		vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-[>", function() harpoon:list():prev() end)
		vim.keymap.set("n", "<C-]>", function() harpoon:list():next() end)
	'';
}
