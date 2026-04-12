{
	description = "CCSP Project";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		espressoMD-flake.url = "path:/home/jay/.dotfiles/programs/extern/espressoMD/";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils, espressoMD-flake, ... }@inputs: 
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs {
					inherit system;
				};
				espressoMD = espressoMD-flake.packages.${system}.espressoMD;
				pythonPkgs = pkgs.python3.withPackages (ps: with ps; [
					matplotlib
					numba
					numpy
					scipy
					tqdm
				]);
			in 
			{
				devShells.default = pkgs.mkShell {
					buildInputs = [
						espressoMD
						pythonPkgs
						pkgs.mpi
					];

					shellHook = ''
						export PYTHONPATH=$(echo ${pkgs.lib.makeSearchPath "lib/python3.11/site-packages" [ espressoMD pythonPkgs ]})
					'';
				};
			}
		);

}
