{
	description = "Rust dev env (NixOS)";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		flake-utils.url = "github:numtide/flake-utils";

		fenix = {
			url = "github:nix-community/fenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		crane.url = "github:ipetkov/crane";
	};

	outputs = { self, nixpkgs, flake-utils, fenix, crane, ... }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs { inherit system; };

				# Stable Rust toolchain + the usual components
				tc = fenix.packages.${system}.stable;
				toolchain = tc.withComponents [
					"cargo"
					"clippy"
					"rust-src"
					"rustc"
					"rustfmt"
				];

				# Optional: make `nix build` work nicely for Rust projects
				craneLib = (crane.mkLib pkgs).overrideToolchain toolchain;
				src = craneLib.cleanCargoSource ./.;
				commonArgs = {
					inherit src;
					strictDeps = true;

					# Add extra deps here if your crate needs them (openssl, sqlite, etc.)
					# nativeBuildInputs = [ pkgs.pkg-config ];
					# buildInputs = [ pkgs.openssl ];
				};

				cargoArtifacts = craneLib.buildDepsOnly commonArgs;
				crate = craneLib.buildPackage (commonArgs // { inherit cargoArtifacts; });
			in
				{
				devShells.default = pkgs.mkShell {
					packages = [
						toolchain
						fenix.packages.${system}.rust-analyzer
					];

					# Helps rust-analyzer find std sources
					RUST_SRC_PATH = "${tc.rust-src}/lib/rustlib/src/rust/library";
				};

				packages.default = crate;
			});
}
