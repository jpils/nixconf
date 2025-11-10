{config, pkgs, inputs, ... }:

let
	ovitoOverlay = (builtins.getFlake "/home/jay/.dotfiles/programs/extern/ovito").overlays.default;
in 
{
	imports = [
		../../programs/tmux/tmux.nix
		../../programs/nvim/nvim.nix
		../../programs/zsh/zsh.nix
		../../programs/stylix/stylix.nix
		../../programs/waybar/waybar.nix
		../../programs/kitty/kitty.nix
	];
	
	
	home.stateVersion = "23.11"; # Please read the comment before changing.

	home.username = "jay";
	home.homeDirectory = "/home/jay";

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	nixpkgs.overlays = [ ovitoOverlay ];

	home.packages = with pkgs; [
		beeper
		blueman
		brightnessctl
		btop
		conda
		discord
		dmenu
		dunst
		fd
		firefox
		libreoffice-qt
		fzf
		gdb
		gnuplot
		inkscape
		jellyfin-ffmpeg
		jmol
		kdePackages.dolphin
		kdePackages.qtsvg
		kitty
		lima
		loupe
		notify
		ovito
		pavucontrol
		picom
		python313
		qalculate-gtk
		ripgrep
		rofi
		sshfs
		starship
		step-cli
		telegram-desktop
		texliveFull
		tree
		vlc
		wl-clipboard
		xournalpp
		zathura
		zip
		zoom-us
		zotero
		zoxide
# fonts
		nerd-fonts.symbols-only
		iosevka
	];

	fonts = {
		fontconfig.enable = true;
	};

	home.file = {
		".config/dunst".source = ../../programs/dunst;
		".config/rofi".source = ../../programs/rofi;
	};
	
# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. If you don't want to manage your shell through Home
# Manager then you have to manually source 'hm-session-vars.sh' located at
# either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/jay/etc/profile.d/hm-session-vars.sh
#

# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
