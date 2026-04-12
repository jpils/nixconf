{ pkgs, ... }:

{
	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			nvim-autopairs
		];
		initLua = /* lua */ ''
			require("nvim-autopairs").setup {}
		'';
	};
}
