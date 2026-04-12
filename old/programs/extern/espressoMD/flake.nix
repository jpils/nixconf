{
  description = "espressoMD";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    cython3-0-9.url = "github:nixos/nixpkgs/92d295f588631b0db2da509f381b4fb1e74173c5";
  };

  outputs = { self, nixpkgs, ... }@inputs:
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs {
			inherit system;
		};
		cython = inputs.cython3-0-9.legacyPackages.${system}.python311Packages.cython;
		boostMpi = pkgs.boost.override {
			useMpi = true;
			mpi = pkgs.openmpi;
		};
	in {
		packages.${system}.espressoMD = pkgs.stdenv.mkDerivation {
			pname = "espressoMD"; 
			version = "4.2.2";
			src = pkgs.fetchFromGitHub {
				owner = "espressomd";
				repo = "espresso";
				rev = "4.2.2";
				sha256 = "sha256-f/rPURva1zx1hoqG3GZ/K3FvKtiLp+qz9Q6BeZBN0lY=";
			};

			nativeBuildInputs = with pkgs; [
				cmake
				cython
				python3
				openmpi
				fftw
				fftwMpi
				boostMpi
				hdf5
				python311Packages.numpy
				python311Packages.scipy
				python311Packages.pyopengl
				gsl
				freeglut
			];

			buildPhase = ''
				cmake ..
				make -j$(nproc)
			'';

			installPhase = ''
				make install PREFIX=$out
			'';
		};
	};
}
