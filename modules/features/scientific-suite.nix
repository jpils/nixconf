{ self, inputs, ... }: {
	flake.nixosModules.scientific-suite = { pkgs, ... }: {
		users.users.jay.packages = with pkgs; [
			gnuplot
			jmol
			ovito
			zotero
		];
	};
}
