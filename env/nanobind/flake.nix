{
	description = "STO_90_DW";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
		pybind11-stubgen-flake.url = "path:/home/jay/.dotfiles/programs/extern/pybind11-stubgen/";
	};

	outputs = { self, nixpkgs, flake-utils, pybind11-stubgen-flake, ... }@inputs:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs {
					inherit system;
				};

				pybind11-stubgen = pybind11-stubgen-flake.packages.${system}.pybind11-stubgen;
				pythonEnv = pkgs.python3.withPackages (ps: with ps; [
					numpy
					matplotlib
					scipy
					ase
					pybind11
					tqdm
				]);

			in
				{
					devShell = pkgs.mkShell {
						nativeBuildInputs = with pkgs; [
							pkg-config 
							cmake
							clang
							eigen
							ninja
						];

						buildInputs = [
							pythonEnv 
							pybind11-stubgen
							pkgs.valgrind
							pkgs.linuxKernel.packages.linux_zen.perf
						];

						shellHook = ''
							export CC=clang
							export CXX=clang++
							export CMAKE_EXPORT_COMPILE_COMMANDS=ON
						'';
					};
				}
		);
}
