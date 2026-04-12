{
	description = "Colbuilder flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils, ... }:
		flake-utils.lib.eachDefaultSystem (system :
			let
				pkgs = import nixpkgs {
					inherit system;
				};
				pythonPackages = pkgs.python3Packages;
			in {
				packages.colbuilder = pythonPackages.buildPythonPackage {
					pname = "colbuilder";
					version = "2.0.0";
					src = pkgs.fetchFromGitHub {
						owner = "graeter-group";
						repo = "colbuilder";
						rev = "2.0.0";
						sha256 = "sha256-LwHXJOw+GVPkeiaF0gNQWEVXHNEh9fl/3pPAlrxaoHw=";
					};

					buildInputs = with pkgs; [
						pymol
						muscle
					];

					propagatedBuildInputs = with pythonPackages; [
						numpy
					];
				};
			}
		);
}
