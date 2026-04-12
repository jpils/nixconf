{ config, inputs, lib, pkgs, ... }:

let
sesh = pkgs.buildGoModule rec {
	pname = "sesh";
	version = "0.15.0"; # Replace this with the actual version

		src = pkgs.fetchFromGitHub {
			owner = "joshmedeski"; # Replace with the actual GitHub owner
				repo = pname;
			rev = "v${version}";
			sha256 = "sha256-vV1b0YhDBt/dJJCrxvVV/FIuOIleTg4mI496n4/Y/Hk="; # Replace with the actual sha256
		};

	vendorHash = "sha256-zt1/gE4bVj+3yr9n0kT2FMYMEmiooy3k1lQ77rN6sTk=";

};
in {
	home.packages = [
		sesh
		#inputs.tmux-sessionx.packages.x86_64-linux.default
	];
	programs.tmux = {
		enable = true;
		shell = "${pkgs.zsh}/bin/zsh";
		prefix = "C-Space";
		mouse = true;
		plugins = with pkgs; [
			{
				plugin = tmuxPlugins.nord;
				extraConfig = '' 
					set -g @catppuccin_flavor 'mocha'
					set -g @catppuccin_window_tabs_enabled on
					set -g @catppuccin_date_time "%H:%M"
					'';
			}
			tmuxPlugins.sensible
			tmuxPlugins.yank
		];
		extraConfig = '' 
			# prefix for nested session

			bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
			set -g detach-on-destroy off  # don't exit from tmux when closing a session

			# navigation between windows
			bind -n M-H previous-window
			bind -n M-L next-window

			# vim-like pane switching
			bind -r ^ last-window
			bind -r k select-pane -U
			bind -r j select-pane -D
			bind -r h select-pane -L
			bind -r l select-pane -R
			
			# rename windows to current directory
			set-option -g status-interval 5
			set-option -g automatic-rename on
			set-option -g automatic-rename-format '#{b:pane_current_path}'

			# bar config
			set -g status-right '%a %d-%m-%Y   %H:%M#[default]' #[fg=b4befe, bold, bg=#1e1e2e]
			set -g status-position top
			#set -g status-style 'bg=#1e1e2e'

			set -g window-status-current-format '  #I: #W' #[fg=magenta, bg=#1e1e2e] 
			set -g window-status-format '  #I: #W' #[fg=grey, bg=#1e1e2e] 
			set -g window-status-last-style 'fg=white, bg=black'

			# window indexing from 1
			set -g base-index 1
			set -g pane-base-index 1
			set-window-option -g pane-base-index 1
			set-option -g renumber-windows on
		'';
	};
}
