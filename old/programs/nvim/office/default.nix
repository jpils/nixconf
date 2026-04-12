{config, pkgs, ... }:

{
	imports = [
		../colorscheme.nix
		../autopairs.nix
		../harpoon.nix
		../ibl.nix
		../lualine.nix
		../jupytext.nix
		../luasnip.nix
		../lsp.nix
		../molten.nix
		../neogen.nix
		../surround.nix
		../telescope.nix
		../trouble.nix
		../treesitter.nix
		../undo.nix
		../vimtex.nix
		../wrapping.nix
		../zenmode.nix
		../opts.nix
		../quarto.nix
		../remap.nix
	];
	
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;
		plugins = with pkgs.vimPlugins; [
			nvim-web-devicons
			plenary-nvim
			obsidian-nvim
		];
	};

}
