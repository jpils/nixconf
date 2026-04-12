{
	description = "Example flake that provides a shell with conda pre-initialized for zsh";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
	};

	outputs = { self, nixpkgs, ... }:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};
		in {
			devShells.${system}.default = pkgs.mkShell {
				buildInputs = [
					pkgs.conda
					pkgs.cmake
					pkgs.mpi
					pkgs.mkl
					pkgs.llvmPackages_20.openmp
					pkgs.cudaPackages.cudatoolkit
					pkgs.cudaPackages.cudnn
				];

				shellHook = ''
					export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
					export STATIC_CUDA_PATH="/nix/store/b9gqmf40k27b14g7xb01rr97349yw6qp-cuda_cudart-12.8.90-static"
					export LIBRARY_PATH=$CUDA_PATH/lib:$CUDA_PATH/lib64:$STATIC_CUDA_PATH/lib:$LIBRARY_PATH
					export LD_LIBRARY_PATH=$CUDA_PATH/lib:$CUDA_PATH/lib64:$LD_LIBRARY_PATH
				  '';
			};
		};
}
