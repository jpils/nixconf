{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		indent-blankline-nvim
	];

	lua = /* lua */ ''
		require("ibl").setup({
			scope = {
				show_start = false,
				show_end = false,
			}
		})
	'';
}
