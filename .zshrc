# ~/.zshrc — plain zsh, no framework. Tools: mise, direnv, starship, eza, yazi.

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history hist_ignore_dups hist_ignore_space share_history

# Shell behaviour
setopt auto_cd interactive_comments
bindkey -e

# Completion
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Config dir for tools that honour XDG (lazygit otherwise uses ~/Library)
export XDG_CONFIG_HOME="$HOME/.config"

# vim for anything that opens an editor: git, gh, lazygit, yazi
export EDITOR="vim"
export VISUAL="vim"

# PATH (typeset -U drops duplicate entries)
typeset -U path PATH
export PATH="$HOME/.local/bin:/opt/homebrew/opt/libpq/bin:$PATH:$HOME/go/bin"

# Aliases
alias ls="eza --long --header --git"
alias lsla="eza --long --header --git -a"
alias tree="eza --tree --level=2"
alias dot='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
alias h="alias"
alias g="git"
alias gsw="git switch"
alias glo="git log -n 3 --oneline"
alias ..="cd .."
alias ...="cd ../.."

# yazi: cd to the directory yazi was in on exit
function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

# lazygit: cd to the directory lazygit was in on exit (repo or worktree switches)
function lg() {
	export LAZYGIT_NEW_DIR_FILE="${TMPDIR:-/tmp}/lazygit-newdir"
	command lazygit "$@"
	if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
		builtin cd -- "$(cat "$LAZYGIT_NEW_DIR_FILE")"
		command rm -f -- "$LAZYGIT_NEW_DIR_FILE"
	fi
}

# Tool hooks: mise first so direnv and starship see mise-managed binaries
eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
# zoxide takes over cd: real paths work as before, anything else matches by frecency (cd myrepo from anywhere)
eval "$(zoxide init zsh --cmd cd)"

# Machine-specific overrides, not tracked in dotfiles
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
