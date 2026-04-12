{ pkgs, ... }:

{
	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			nvim-surround
		];
		initLua = /* lua */ ''
			require("nvim-surround").setup({})
		'';
	};
}
