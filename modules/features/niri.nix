{ self, inputs, ... }: {
	flake.nixosModule.niri = {pkgs, lib, self', ... }: {
		programs.niri = { 
			enable = true;
			package = self'.packages.myNiri;
		};
	};

	perSystem = {pkgs, lib, self', ... }: {
		packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
			inherit pkgs;
			settings = {
				spawn-at-startup = [
					(lib.getExe self'.packages.myNoctalia)
				];

				xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
				
				input.keyboard = {
					xkb.layout = "us,dvorak";
				};

				layout.gaps = 5;

				binds = {
					"Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
					"Mod+T".spawn-sh = lib.getExe pkgs.ghostty;
					"Mod+C".close-window = _: {};
				};
			};
		};
	};
}
