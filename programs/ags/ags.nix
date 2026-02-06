{ inputs, pkgs, ... }:
{
# add the home manager module
	imports = [ inputs.ags.homeManagerModules.default ];

	home.packages = with pkgs; [
		adwaita-icon-theme
	];

	programs.ags = {
		enable = true;

# symlink to ~/.config/ags
		configDir = ./config;

# additional packages and executables to add to gjs's runtime
		extraPackages = with pkgs; [
			inputs.astal.packages.${pkgs.system}.battery
			inputs.astal.packages.${pkgs.system}.bluetooth
			inputs.astal.packages.${pkgs.system}.network
			inputs.astal.packages.${pkgs.system}.hyprland
			fzf

			brightnessctl
			swww
		];
	};
}
