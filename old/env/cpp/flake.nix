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
			in
				{
					devShell = pkgs.mkShell {
						nativeBuildInputs = with pkgs; [
							pkg-config 
							cmake
							eigen
							ninja
						];

						buildInputs = [
							pkgs.valgrind
							pkgs.linuxKernel.packages.linux_zen.perf
						];

						shellHook = ''
							export CMAKE_EXPORT_COMPILE_COMMANDS=ON
						'';
					};
				}
		);
}
