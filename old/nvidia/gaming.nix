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
			package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
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

	environment.sessionVariables = {
		WLR_DRM_DEVICES = "/dev/dri/card1";
		GBM_BACKEND = "nvidia-drm";
	};

	services.dbus.enable = true;

	programs.gamemode.enable = true;

	programs.coolercontrol.enable = true;
}
