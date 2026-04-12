{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		nord-nvim
	];

	lua = /* lua */ '' 
		vim.cmd[[colorscheme nord]]

		vim.opt.termguicolors = true
	'';
}
