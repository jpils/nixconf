{pkgs, config, ... }:

{
	hardware = {
		graphics = {
			enable = true;
		};

		nvidia = {
			open = true;
			nvidiaSettings = true;
			modesetting.enable = true;
			powerManagement.enable = false;
			powerManagement.finegrained = false;
			package = config.boot.kernelPackages.nvidiaPackages.latest;
		};
	};
		
	services.xserver.videoDrivers = ["nvidia"];

	environment.systemPackages = with pkgs; [
		dconf
		dconf-editor
	];

	services.dbus.enable = true;

	programs.coolercontrol.enable = true;
}
