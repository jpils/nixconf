{ self, ... }: {
	flake.nixosModules.cursor = { pkgs, lib, ... }: {
		# Install the cursor package
		environment.systemPackages = [ pkgs.bibata-cursors ];

		# Tell Wayland apps (like Niri and Ghostty) which cursor and size to use
		environment.variables = {
			XCURSOR_THEME = "Bibata-Modern-Ice";
			XCURSOR_SIZE = "20";
		};

		# Tell GTK applications to use it
		programs.dconf.enable = true;
		programs.dconf.profiles.user.databases = [
			{
				settings = {
					"org/gnome/desktop/interface" = {
						cursor-theme = "Bibata-Modern-Ice";
						cursor-size = lib.gvariant.mkInt32 20;
					};
				};
			}
		];
	};
}
