export LC_ALL="en_US.UTF-8"
export ZSH="$HOME/.oh-my-zsh"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export GOBIN="${GOPATH}/bin"
export PATH=$PATH:${GOPATH}/bin:${GOROOT}/bin
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.cargo/bin
export BAT_THEME=TwoDark

if [ -d "/usr/homebrew/opt/ruby/bin" ]; then
  export PATH=/usr/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
elif [ -d "/usr/local/opt/ruby/bin" ]; then
  export PATH=/usr/local/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# use ripgrep inside vim for fzf
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'

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
  nvm
  asdf
)

source $ZSH/oh-my-zsh.sh

# aliases
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs"
alias dcr="docker compose restart"
alias ku="kubectl"
alias rn="react-native"
alias rproxy='adb reverse tcp:9090 tcp:9090'
alias gco='git checkout'
alias gpr='git push -u origin HEAD'
alias gcb='git checkout -b'
alias vim="nvim"
alias cat="bat"
alias tn="tmux new -A -s"
alias ta="tmux a -t"
alias tk="tmux kill-session -t"

# Removes merged git branches
function gcmb {
  git branch --merged | grep -Ev '^(\*|  master$)' | xargs git branch -d ;
}

# tabtab source for packages
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^k' autosuggest-accept
bindkey -s ^f "tmux-session-switch\n"

if [ -d "/usr/homebrew/opt/asdf" ]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -d "/usr/local/opt/aadf" ]; then
  . /usr/local/opt/asdf/libexec/asdf.sh
fi

export AWS_PROFILE=sts

# DuskFox theme for FZF
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#e0def4,bg:#232136,hl:#569fba
 --color=fg+:#e0def4,bg+:#433c59,hl+:#65b1cd
 --color=info:#a6dae3,prompt:#f6c177,pointer:#c4a7e7
 --color=marker:#a3be8c,spinner:#c4a7e7,header:#c4a7e7'


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

