{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		nvim-autopairs
	];
	lua = /* lua */ ''
		require("nvim-autopairs").setup {}
	'';
}
