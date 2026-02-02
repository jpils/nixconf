{ pkgs, ... }:

{
	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			zen-mode-nvim
		];
		initLua = /* lua */ ''
			require("zen-mode").setup()
			vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")
		'';
	};
}
