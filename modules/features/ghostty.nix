{ self, inputs, ... }: {
	flake.nixosModules.ghostty = { pkgs, lib, ... }: {
		environment.systemPackages = [ 
			self.packages.${pkgs.system}.ghostty 
		];
	};

	perSystem = { pkgs, lib, self', ... }: {
		packages.ghostty = inputs.wrapper-modules.lib.wrapPackage {
			inherit pkgs;
			package = pkgs.ghostty;
			
			flags = {
				"--confirm-close-surface" = "false";
				"--clipboard-read" = "allow";
				"--window-decoration" = "false";
				"--window-inherit-working-directory" = "false";
				"--font-size" = "10";
				"--font-family" = [
					"Iosevka"
					"Noto Color Emoji"
				];
				
				# Use the explicit aliases from your theme!
				"--background" = self.themeNoHash.bg;
				"--foreground" = self.themeNoHash.fg;
				"--cursor-color" = self.themeNoHash.fg;
				"--selection-background" = self.themeNoHash.selectionBg;
				"--selection-foreground" = self.themeNoHash.fg;
				
				# Mapped sequentially from 0 to 15
				"--palette" = [
					"0=#${self.themeNoHash.base00}"
					"1=#${self.themeNoHash.base01}"
					"2=#${self.themeNoHash.base02}"
					"3=#${self.themeNoHash.base03}"
					"4=#${self.themeNoHash.base04}"
					"5=#${self.themeNoHash.base05}"
					"6=#${self.themeNoHash.base06}"
					"7=#${self.themeNoHash.base07}"
					"8=#${self.themeNoHash.base08}"
					"9=#${self.themeNoHash.base09}"
					"10=#${self.themeNoHash.base10}"
					"11=#${self.themeNoHash.base11}"
					"12=#${self.themeNoHash.base12}"
					"13=#${self.themeNoHash.base13}"
					"14=#${self.themeNoHash.base14}"
					"15=#${self.themeNoHash.base15}"
				];
			};
			flagSeparator = "="; 
		};
	};
}
