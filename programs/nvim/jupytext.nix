{ pkgs, ... }:

{
	home.packages = with pkgs; [
		python3Packages.jupytext
	]; 

	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			jupytext-nvim
		];
        #extraPython3Packages = ps: with ps; [
		#	jupytext
		#];
		initLua = /* lua */ ''
			require("jupytext").setup({
				style = "markdown",
				output_extension = "md",
				force_ft = "markdown",
			})
		'';
	};
}
