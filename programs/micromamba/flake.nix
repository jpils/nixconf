{
  description = "Overlay: build micromamba with gcc13 on any channel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05;
  };

  outputs = { self, nixpkgs }:
  let
    micromambaGcc13Overlay = final: prev: {
      micromamba = prev.micromamba.overrideAttrs (old: {
        stdenv = prev.gcc13Stdenv;
      });
    };
  in
  {
    overlays.default = micromambaGcc13Overlay;

    homeModules.default = { pkgs, ... }: {
      nixpkgs.overlays = [ micromambaGcc13Overlay ];
      home.packages = [ pkgs.micromamba ];
    };
  };
}
