{
	description = "lammps with mace interface";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs = { self, nixpkgs, ... }@inputs:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
			};
		in {
			packages.${system}.lammps_mace = pkgs.stdenv.mkDerivation {
				pname = "lammps"; 
				version = "4.2.2";
				src = pkgs.fetchFromGitHub {
					owner = "ACEsuit";
					repo = "lammps";
					rev = "mace";
					sha256 = "sha256-UQfi5V+dD/g9VUdF+8eui3pntkTdFSObpR/8+qMM4PU=";
				};

				nativeBuildInputs = with pkgs; [
					cmake
				];
				
				buildInputs = with pkgs; [
					openmpi
					libtorch-bin
				];

				cmakeFlags = [
					"-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
					"-D CMAKE_CXX_STANDARD=17"
					"-D CMAKE_CXX_STANDARD_REQUIRED=ON"
					"-D BUILD_MPI=ON"
					"-D BUILD_OMP=ON"
					"-D PKG_OPENMP=ON"
					"-D PKG_ML-MACE=ON"
					"-D CMAKE_PREFIX_PATH=${pkgs.libtorch-bin}"
					"../cmake"
				];
			};
		};
}
