{ config, pkgs, ... }:

{
	programs.ghostty = {
		enable = true;
# Optional: Define your settings directly in Nix
		settings = {
			window-decoration = false;
		};
	};
}
