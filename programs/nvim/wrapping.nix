{ pkgs, ... }:

{
	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			wrapping-nvim
		];
		initLua = /* lua */ ''
			require("wrapping").setup()
		'';
	};
}
