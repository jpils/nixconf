{
  description = "FHS env for micromamba";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      fhs = pkgs.buildFHSEnv {
        name = "fhs-shell";
        targetPkgs = pkgs: with pkgs; [
          coreutils curl gcc wget zsh
          micromamba glibc openssl stdenv.cc.cc
        ];

        # Profile is still good for environment variables
        profile = ''
          export MAMBA_ROOT_PREFIX="$PWD/.mamba"
          export MAMBA_NO_BANNER=1
        '';

        # This script runs when you enter 'nix develop'
        runScript = pkgs.writeShellScript "mamba-setup" ''
          # 1. Create a temporary directory for our custom Zsh config
          # This avoids cluttering your home directory.
          export ZDOTDIR=$(mktemp -d)
          
          # 2. Create a .zshrc that hooks micromamba
          # We source your real ~/.zshrc so you keep your prompt/theme
          cat <<EOF > "$ZDOTDIR/.zshrc"
          # Source global zsh config if it exists
          [[ -f ~/.zshrc ]] && source ~/.zshrc

          # Initialize micromamba functions
          eval "\$(micromamba shell hook --shell zsh)"

          # Optional: Auto-create mamba root if it doesn't exist
          mkdir -p "\$MAMBA_ROOT_PREFIX"

          # Clean up the temp directory when you exit the shell
          trap 'rm -rf "$ZDOTDIR"' EXIT
EOF

          # 3. Launch the interactive shell
          exec zsh
        '';
      };
    in
    {
      devShells.${system}.default = fhs.env;
    };
}
