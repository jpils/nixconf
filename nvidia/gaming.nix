{pkgs, config, ... }:

{
	hardware = {
		graphics = {
			enable = true;
			enable32Bit = true;
		};

		nvidia = {
			open = false;
			nvidiaSettings = true;
			modesetting.enable = true;
			powerManagement.enable = false;
			package = config.boot.kernelPackages.nvidiaPackages.production;
		};
	};
		
	services.xserver.videoDrivers = ["nvidia"];

	programs.steam.enable = true;
	programs.steam.gamescopeSession.enable = true;

	environment.systemPackages = with pkgs; [
		mangohud
		dconf
		dconf-editor
	];

	services.dbus.enable = true;

	programs.gamemode.enable = true;

	programs.coolercontrol.enable = true;
}
