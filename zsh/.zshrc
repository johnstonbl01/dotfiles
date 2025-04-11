export PATH=$HOME/.bin:$PATH
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export ANDROID_HOME="/Users/blake/Library/Android/sdk"

export ZSH="$HOME/.oh-my-zsh"
export BAT_THEME=TwoDark

# use ripgrep inside vim for fzf
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"


# change node version on cd with fnm
eval "$(fnm env --use-on-cd)"
# fnm autocomplete
fpath+="/opt/homebrew/share/zsh/site-functions"
autoload -Uz compinit
compinit

# Set default user
# Will show server named if SSH'd
[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="blake"

ZSH_THEME="dieter-custom"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_TITLE="true"
HIST_STAMPS="mm/dd/yyyy"

# zsh plugins
plugins=(
	git
	macos
	jsontools
	npm
	zsh-autosuggestions
	autojump
)

source $ZSH/oh-my-zsh.sh

# aliases
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dcl="docker-compose logs"
alias dcr="docker-compose restart"
alias rn="react-native"
alias gco='git checkout'
alias gpr='git push -u origin HEAD'
alias gcb='git checkout -b'
alias tn="tmux new -A -s"
alias ta="tmux a -t"
alias tk="tmux kill-session -t"
alias vim="nvim"
alias cat="bat"
alias grep="rg"
alias npm="pnpm"
alias npx="pnpm exec"
alias onpm="npm"

# Removes merged git branches
function gcmb {
	git branch --merged | grep -Ev '^(\*|  master$)' | xargs git branch -d
}

# autojump setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf fuzzy auto-complete
eval "$(fzf --zsh)"

bindkey '^n' autosuggest-accept
bindkey -s ^f "tmux-session-switch\n"

# DuskFox theme for FZF
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=fg:#e0def4,bg:#232136,hl:#569fba
--color=fg+:#e0def4,bg+:#433c59,hl+:#65b1cd
--color=info:#a6dae3,prompt:#f6c177,pointer:#c4a7e7
--color=marker:#a3be8c,spinner:#c4a7e7,header:#c4a7e7'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
		. "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
	else
		export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/Users/blake/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
