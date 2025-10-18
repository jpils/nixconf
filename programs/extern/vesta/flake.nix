{
  description = "VESTA (GTK3) packaged as a flake (x86_64/aarch64 Linux)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: builtins.listToAttrs (map (system: {
      name = system;
      value = f system;
    }) systems);

    mkVesta = system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        # Pick the right upstream tarball per-arch (GTK3 builds).
        upstreamUrl =
          if system == "x86_64-linux"
          then "https://jp-minerals.org/vesta/archives/testing/VESTA-gtk3-x86_64.tar.bz2"
          else "https://jp-minerals.org/vesta/archives/testing/VESTA-gtk3-arm64.tar.bz2";

        # Bump this when you update URLs above.
        vestaVersion = "3.90.5a";

        vestaSrc = pkgs.fetchurl {
          url = upstreamUrl;
          # Step 1: run `nix build .#vesta` to get a "got: sha256-…" message.
          # Step 2: paste that value here instead of lib.fakeSha256 and rebuild.
          sha256 = "sha256-WvO+Rc0Z1LYBudPhkNOf2M9m8BPgEkIIOYR7tFGaM6Y=";
        };

        desktopFile = ''
          [Desktop Entry]
          Name=VESTA
          Comment=3D visualization program for crystal structures
          Exec=vesta %F
          Terminal=false
          Type=Application
          Categories=Science;Education;Chemistry;Physics;Graphics;
          Icon=vesta
        '';
      in
      {
        vesta = pkgs.stdenvNoCC.mkDerivation {
          pname = "vesta";
          version = vestaVersion;
          src = vestaSrc;

          nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.wrapGAppsHook ];
          buildInputs = with pkgs; [
            gtk3 glib gdk-pixbuf pango cairo atk
            fontconfig freetype
            xorg.libX11 xorg.libXext xorg.libXrender xorg.libXrandr
            xorg.libXi xorg.libXcursor xorg.libSM xorg.libICE
            libGL libGLU
          ];

          # VESTA is a binary drop; just install and wrap it.
          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/vesta $out/bin \
                     $out/share/applications \
                     $out/share/icons/hicolor/256x256/apps
            cp -a * $out/share/vesta/

            # Main launcher
            install -Dm755 $out/share/vesta/VESTA $out/bin/vesta

            # Desktop entry + icon (if present in tarball)
            printf '%s\n' '${desktopFile}' > $out/share/applications/vesta.desktop
            if [ -f "$out/share/vesta/VESTA.png" ]; then
              install -Dm644 "$out/share/vesta/VESTA.png" \
                $out/share/icons/hicolor/256x256/apps/vesta.png
            fi
            runHook postInstall
          '';

          postFixup = ''
            # Wrap with GTK env so themes/fonts/etc. work
            wrapGApp $out/bin/vesta
          '';

          meta = with lib; {
            description = "VESTA crystal/molecule visualizer (GTK3 binary wrapper)";
            homepage = "https://jp-minerals.org/vesta/en/";
            license = licenses.unfreeRedistributable;
            platforms = [ system ];
            mainProgram = "vesta";
          };
        };

        # Fallback: run upstream binary inside a minimal FHS env
        vesta-fhs = pkgs.buildFHSEnvBubblewrap {
          name = "vesta-fhs";
          targetPkgs = p: with p; [
            gtk3 glib gdk-pixbuf pango cairo atk
            fontconfig freetype
            xorg.libX11 xorg.libXext xorg.libXrender xorg.libXrandr
            xorg.libXi xorg.libXcursor xorg.libSM xorg.libICE
            libGL libGLU
          ];
          runScript = "${self.packages.${system}.vesta-src}/opt/vesta/VESTA";
          # Provide the upstream files as a separate derivation under /opt
          extraMounts = [
            {
              source = "${self.packages.${system}.vesta-src}/opt/vesta";
              target = "/opt/vesta";
              recursive = true;
            }
          ];
        };

        # Internal: materialize the upstream archive into the store for the FHS runner.
        vesta-src = pkgs.stdenvNoCC.mkDerivation {
          pname = "vesta-src";
          version = vestaVersion;
          src = vestaSrc;
          installPhase = ''
            mkdir -p $out/opt/vesta
            cp -a * $out/opt/vesta/
          '';
        };
      };
  in
  {
    packages = forAllSystems (system:
      let r = mkVesta system; in {
        vesta = r.vesta;
        vesta-fhs = r.vesta-fhs;
        default = r.vesta;
      });

    # `nix run .`
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.vesta}/bin/vesta";
      };
    });

    # Optional overlay for importing into your own pkgs set
    overlays.default = final: prev: let
      system = final.stdenv.hostPlatform.system;
    in {
      vesta = self.packages.${system}.vesta;
      vesta-fhs = self.packages.${system}.vesta-fhs;
    };
  };
}
