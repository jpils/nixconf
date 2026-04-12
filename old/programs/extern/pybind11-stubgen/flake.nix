{
	description = "pybind11-stubgen CLI tool";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils, ... }: 
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs {
					inherit system;
				};
				pythonPackages = pkgs.python3Packages;
			in {
				packages.pybind11-stubgen = pythonPackages.buildPythonPackage {
					pname = "pybind11-stubgen";
					version = "2.5.1";
					src = pkgs.fetchFromGitHub {
						owner = "sizmailov";
						repo = "pybind11-stubgen";
						rev = "v2.5.1";
						sha256 = "sha256-PJiiRSQ92vP5LKWCgBuowkuDdTmC22xyuax2wsH0wOM=";
					};

					buildInputs = [
						pythonPackages.setuptools 
					];
				};
			}
		);
}
