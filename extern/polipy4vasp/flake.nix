{
	description = "flake for polipy4vasp"

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, ... }@inputs:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
			};
		in {
			pack
		};
}
