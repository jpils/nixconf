{ self, inputs, ... }: {
	flake.nixosModules.nushell = { pkgs, ... }: {
		environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nushell ];
		environment.shells = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nushell ];
	};

	perSystem = { pkgs, lib, self', ... }: {
		packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
			inherit pkgs;

			extraPackages = with pkgs; [
				fzf
				fd
				starship
				zoxide
				direnv
				sesh
				carapace
				neovim
			];

			env = {
				KEYTIMEOUT = "20";
			};

			"config.nu".content = ''
				alias v = nvim
				alias l = ls
				alias la = ls -l
				alias ts = tmux new -s

				$env.config.edit_mode = "vi"
				$env.config.cursor_shape = {
				  vi_insert: "line"
				  vi_normal: "block"
				}

				$env.STARSHIP_SHELL = "nu"

				def create_left_prompt [] {
					starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
				}

# Use nushell functions to define your right and left prompt
				$env.PROMPT_COMMAND = { || create_left_prompt }
				$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
				$env.PROMPT_INDICATOR = ""
				$env.PROMPT_MULTILINE_INDICATOR = "::: "
			'';
		};
	};
}
