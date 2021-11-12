export LC_ALL="en_US.UTF-8"
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export NVM_COMPLETION=true
export DEFAULT_AVD='Pixel 4 API 29'
export ANDROID_HOME="$HOME/Library/Android/sdk"
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export BAT_THEME=TwoDark

# use ripgrep inside vim for fzf
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

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
)

source $ZSH/oh-my-zsh.sh

# NVMrc config for ZSH
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# launches the optionally specified AVD
# With no argument, it will use $DEFAULT_AVD or the first available AVD
# e.g.: LaunchAvdForeground Nexus_5X_API_23
function LaunchAvdForeground {
  local avdName=${1:-$DEFAULT_AVD}
  echo "Launching AVD: $avdName"
  $ANDROID_HOME/emulator/emulator -netdelay none -netspeed full -avd $avdName
}

# aliases
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias devChrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_session" --disable-web-security'
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs"
alias dcr="docker compose restart"
alias ku="kubectl"
alias rn="react-native"
alias rproxy='adb reverse tcp:9090 tcp:9090'
alias aem="LaunchAvdForeground"
alias rnlogcat='adb logcat -s ReactNative:V ReactNativeJS:V'
alias gco='git checkout'
alias gpr='git push -u origin HEAD'
alias gpo='git pull origin ${git rev-parse --symbolic-full-name --abrev-ref HEAD}'
alias gcb='git checkout -b'
alias vim="nvim"
alias cat="bat"
alias nr="npm run"
alias econf="cp ~/dev/dotfiles/project-files/.editorconfig ."

# Removes merged git branches
function gcmb {
  git branch --merged | grep -Ev '^(\*|  master$)' | xargs git branch -d ;
}

# tabtab source for packages
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^ ' autosuggest-accept

