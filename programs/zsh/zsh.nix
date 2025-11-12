{ config, pkgs, ... }:

{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		initContent = /*bash*/''
			# Lines configured by zsh-newuser-install
			HISTFILE=~/.histfile
			HISTSIZE=100000
			SAVEHIST=100000

			autoload -U compinit
			zstyle ':completion:*' menu select
			zmodload zsh/complist
			compinit
			_comp_options+=(globdots) #include dotfiles

			# vim mode
			bindkey -v
			bindkey -M menuselect 'h' vi-backward-char
			bindkey -M menuselect 'k' vi-up-line-or-history
			bindkey -M menuselect 'l' vi-forward-char
			bindkey -M menuselect 'j' vi-down-line-or-history
			export KEYTIMEOUT=20

			export CMAKE_EXPORT_COMPILE_COMMANDS=1

			if [ "$IS_PC" = "true" ]; then
				export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH"
				export LIBGL_DRIVERS_PATH="/run/opengl-driver/lib/dri"
			fi


			# aliases
			alias v="nvim"
			alias l="ls --color=auto -lh"
			alias la="ls --color=auto -lah"
			#alias jukit_kitty="kitty --listen-on=unix:@"$(date +%s%N)" -o allow_remote_control=yes"
			alias remote1="sshfs jpils000@login.leonardo.cineca.it:/leonardo_scratch/fast/L-AUT_023/STO_twinned/production_active_learning remote1"
			alias tn="tmux-new"
			alias ts="tmux new -s"
			alias cd="z"
			alias fzf-custom="fzf --multi \
				--height=50% \
				--margin=5%,2%,2%,5% \
				--layout=reverse-list \
				--border=rounded \
				--info=inline \
				--prompt='> ' \
				--pointer='→' \
				--marker='▶' \
				--color='dark,fg:blue'"
			alias run-vm="/home/jay/.VM/run-vm.sh"
			alias leonardo="source ~/.dotfiles/leonardo.sh"
			alias univie='nmcli connection up id "univie" --ask'
			alias gdb="gdb -q"

			export FZF_DEFAULT_OPTS=" \
			--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
			--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
			--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

			#load zsh syntax highlighting
			source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

			if [ -n "$${commands[fzf-share]}" ]; then
			  source "$(fzf-share)/completion.zsh"
			fi

			find-directories-widget() {
				local dir
				dir=$(fd --type d | fzf-custom ) || {
					zle reset-prompt
					return
				}
				LBUFFER+="$dir"
				zle reset-prompt
			}

			find-hidden-directories-widget() {
				local dir
				dir=$(fd --type d --hidden | fzf-custom) || {
					zle reset-prompt
					return
				}
				LBUFFER+="$dir"
				zle reset-prompt
			}

			find-command-hist-widget() {
				local command
				command=$(history | fzf-custom | awk '{$1=""; print $0}') || return
				LBUFFER+="$command"
				print -s -- "$command"
				zle reset-prompt
			}

			find-file-widget() {
				local file
				file=$(fd --type f | fzf-custom) || {
					zle reset-prompt
					return
				}
				LBUFFER+="$file"
				zle reset-prompt
			}

			zle -N find-directories-widget
			zle -N find-hidden-directories-widget
			zle -N find-command-hist-widget
			zle -N find-file-widget

			bindkey '^t' find-directories-widget
			bindkey '^h' find-hidden-directories-widget
			bindkey '^s' find-all-directories-widget
			bindkey '^r' find-command-hist-widget
			bindkey '^f' find-file-widget

			source /usr/share/autojump/autojump.zsh 2>/dev/null

			tmux-new() {
				session=$(sesh list | fzf-custom)
				sesh connect "$session"
			}

			stty -ixon

			eval "$(zoxide init zsh)"
			eval "$(direnv hook zsh)"
		'';
	};

	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.direnv = {
		enable = true;
		enableZshIntegration = true;
		nix-direnv.enable = true;
	};
}


