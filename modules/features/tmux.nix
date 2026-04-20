{ self, inputs, ... }: {
	flake.nixosModules.tmux = { pkgs, lib, ... }: {
		programs.tmux = {
			enable = true;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.tmux;
		};
	};

	perSystem = { pkgs, lib, self', ... }: {
		packages.tmux = inputs.wrapper-modules.wrappers.tmux.wrap {
			inherit pkgs;
			plugins = with pkgs.tmuxPlugins; [
				nord
				sensible
				yank
			];

			configBefore = ''
				# Set prefix to Space (C-Space)
				unbind C-b
				set -g prefix C-Space
				bind C-Space send-prefix

				# Core Settings
				set -g default-shell ${pkgs.zsh}/bin/zsh
				set -g mouse on
				set -g base-index 1
				set -g pane-base-index 1
				set-window-option -g pane-base-index 1
				set-option -g renumber-windows on

				# Enable True Color, Italics, and Undercurls
				set -g default-terminal "tmux-256color"
				set -ag terminal-overrides ",xterm-256color:RGB,xterm-ghostty:RGB"
				set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
				
				# Allow Ghostty's special escape sequences (like the lock icon) to pass through
				set -g allow-passthrough on
				
				# Plugin Configs (Catppuccin via Nord plugin)
				set -g @catppuccin_flavor 'mocha'
				set -g @catppuccin_window_tabs_enabled on
				set -g @catppuccin_date_time "%H:%M"
			'';

			configAfter = ''
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

				set -g window-status-current-format '  #I: #W' #[fg=magenta, bg=#1e1e2e] 
				set -g window-status-format '  #I: #W' #[fg=grey, bg=#1e1e2e] 
				set -g window-status-last-style 'fg=white, bg=black'
			'';
		};
	};
}
