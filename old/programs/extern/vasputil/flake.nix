{
	description = "vasputil";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};
	outputs = { self, nixpkgs }: 
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
			};
			pythonPackages = pkgs.python3Packages;
			vasputil-src = pkgs.fetchFromGitHub {
				owner = "jabl";
				repo = "vasputil";
				rev = "v6.1";
				sha256 = "sha256-W7nDhzW9dUxgjHd1+1b3wEacg9AQnozBN1R423Xd6c8=";
			};
		in {
			packages.${system}.vasputil = pythonPackages.buildPythonPackage {
				pname = "vasputil";
				version = "6.1";
				src = vasputil-src;

				propagatedBuildInputs = with pythonPackages; [
					numpy
					ase
					matplotlib
					scipy
				];

				postPatch = ''
					substituteInPlace setup.py --replace "version='master'" "version='6.1'"
				'';
			};
	};
}
