{
	description = "openMM + MACE";

	inputs = {

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";

	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem ( system:
			let 
				pkgs = import nixpkgs {
					inherit system;
				};


				pythonPackages = pkgs.python312Packages;

				mace = pythonPackages.buildPythonPackage {
					pname = "mace";
					version = "0.3.14";

					src = pkgs.fetchFromGitHub {
						owner = "ACEsuit";
						repo = "mace";
						rev = "v0.3.14";
						sha256 = pkgs.lib.fakeSha256;
					};
					
					format = "pyproject";
					propagatedBuildInputs = with pythonPackages; [];
				};
				 
				pythonEnv = pkgs.python312.withPackages( ps: with ps; [
					openmm
					torch
					numpy
					tqdm
					ase
					matplotlib
				]) ++ [ mace ];

			in
			{
				packages.mace = mace;
				devShells.default = pkgs.mkShell {
					
					buildInputs = [
						pythonEnv
					];

				};
			});
}
