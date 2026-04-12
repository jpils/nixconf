{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		zen-mode-nvim
	];

	lua = /* lua */ ''
		require("zen-mode").setup()
		vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")
	'';
}
