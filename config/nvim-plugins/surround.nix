{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		nvim-surround
	];

	lua = /* lua */ ''
		require("nvim-surround").setup({})
	'';
}
