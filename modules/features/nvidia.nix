{ self, inputs, ... }: {
	flake.nixosModules.nvidia = { config, lib, pkgs, ... }: {
		hardware.graphics = {
			enable = true;
			enable32Bit = true;
		};

		services.xserver.videoDrivers = [ "nvidia" ];

		hardware.nvidia = {
			modesetting.enable = true;

			powerManagement.enable = false;
			powerManagement.finegrained = false;

			open = false;

			nvidiaSettings = true;

			package = config.boot.kernelPackages.nvidiaPackages.stable;
		};

		environment.sessionVariables = {
			WLR_NO_HARDWARE_CURSORS = "1";
		};
	};
}
