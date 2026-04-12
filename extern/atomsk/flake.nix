{
  description = "Atomsk (build from source)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs   = import nixpkgs { inherit system; };
  in {
    # `nix build .#atomsk`
    packages.${system}.atomsk = pkgs.stdenv.mkDerivation rec {
      pname    = "atomsk";
      version  = "0.13.1";

      src = pkgs.fetchFromGitHub {
        owner  = "pierrehirel";
        repo   = "atomsk";
        rev    = "Beta-${version}";
        hash   = "sha256-KNl9VzBrp3uwt5aRrigA4XeS671RpMkIEVAI+3+AoMw=";
      };

      ## -------- build-time dependencies --------
      nativeBuildInputs = with pkgs; [
        gfortran              # provides the Fortran compiler
        pkg-config            # Makefile tests for LAPACK with it
      ];

      ## -------- runtime / link-time deps --------
      buildInputs = with pkgs; [
        openblas              # BLAS + LAPACK in one package
      ];

      ## --- build & install ---
      buildPhase = ''
        make -C src atomsk FC=gfortran \
             LIBS="-L${pkgs.openblas}/lib -lopenblas -fopenmp"
      '';

installPhase = ''
  mkdir -p $out/bin
  cp src/atomsk $out/bin/
'';

    };

  };
}
