{ config, pkgs, lib, ... }:

{
	xdg.configFile = {
		"ghostty/conf.ghostty".text = ''
			title = " "
			window-decoration = false
			window-inherit-working-directory = false
			font-size = 10
		'';
	};

}
