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

	flake.nixosModules.nvidia-pascal = { config, lib, pkgs, ... }: {
		hardware.graphics = {
			enable = true;
			enable32Bit = true;
			extraPackages = with pkgs; [
				nvidia-vaapi-driver
			];
		};

		services.xserver.videoDrivers = [ "nvidia" ];

		hardware.nvidia = {
			modesetting.enable = true;

			# Pascal benefits from PM being on (suspend/resume fixes).
			powerManagement.enable = true;
			powerManagement.finegrained = false;

			# Pascal is NOT supported by the open kernel modules.
			open = false;

			nvidiaSettings = true;

			# Pascal is on the legacy/production branch upstream.
			# `production` is more conservative than `stable` and is the
			# recommended pin for 10-series cards going forward.
			package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
		};

		environment.sessionVariables = {
			WLR_NO_HARDWARE_CURSORS = "1";
			# Enable VA-API through NVDEC for Firefox/Chromium/mpv.
			NVD_BACKEND = "direct";
			LIBVA_DRIVER_NAME = "nvidia";
		};
	};
}
