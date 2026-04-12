{ self, inputs, ... }:{

	flake.nixosModules.user-apps = { pkgs, ... }: {
	    users.users.jay.packages = with pkgs; [
			baobab
			celluloid
			discord
			evince
			file-roller
			geary
			geary              
			gnome-calculator
			gnome-calendar    
			gnome-text-editor
			loupe
			mission-center
			mpv
			nautilus
			spotify
			sushi
			telegram-desktop
			vlc
			xournalpp

			inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	    ];
	};
}
