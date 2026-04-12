{
  description = "Overlay: use OVITO from the stable branch on any channel";

  inputs = {
    # your normal channel – can be nixos-unstable, but doesn't matter
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # the branch you want OVITO from
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable }:
  let
    # one overlay that we’ll export
    ovitoStableOverlay = final: prev:
      let
        # import the *stable* package set for the same CPU arch
        pkgsStable = import nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
        };
      in
      {
        ovito = pkgsStable.ovito;
      };
  in
  {
    overlays.default = ovitoStableOverlay;

    # optional convenience module — lets flake users just `imports = [ ... ]`
    homeModules.default = { pkgs, ... }: {
      nixpkgs.overlays = [ ovitoStableOverlay ];
      home.packages = [ pkgs.ovito ];
    };
  };
}
