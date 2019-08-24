[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # NVM

# Set default user
# Will show server named if SSH'd
[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="blake"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="dieter"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git osx gulp jsontools npm jump)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export DEFAULT_AVD='Pixel_2_API_26'

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
alias dev='cd ~/dev'
# docker-compose alias
alias dc="docker-compose"
# react-native alias
alias rn="react-native"
# kubectl alias
alias ku="kubectl"
# android emulator
alias aem="LaunchAvdForeground"
# redo a git commit
alias redo="git reset --soft HEAD^ && git commit -a -c ORIG_HEAD"
# git checkout
alias gco='git checkout'
# android emulator reverse proxy
alias rproxy='adb reverse tcp:9090 tcp:9090'
# react native branch switch
alias rnrefresh='rm -rf ios/build && rm -rf ios/Pods && npm i && cd ios && pod install && cd ..'
# react native adb logs
alias rnlogcat='adb logcat *:S ReactNative:V ReactNativeJS:V'
# npm link replacement using npm pack
alias npmlink="npmLink"

# Creates an npm package and copies it to the output location provided
function npmLink()
{
  if [ "$1" != "" ]; then
    cp $(npm pack | tail -n 1) "$1"
  else
    echo "No output location provided"
  fi
}

# Removes merged git branches
function gcmb {
  git branch --merged | grep -Ev '^(\*|  master$)' | xargs git branch -d ;
}

# NVM version shortcut
# change title name of tab in terminal
function title {
    echo -ne "\033]0;"$*"\007"
}

cd() {
  builtin cd "$@" || return
  #echo $PREV_PWD
  if [ "$PWD" != "$PREV_PWD" ]; then
    PREV_PWD="$PWD";
    title $(echo ${PWD##*/}) $(node -v);
    if [ -e ".nvmrc" ]; then
      nvm use;
      # set tab terminal name to be cwd and node version
      title $(echo ${PWD##*/}) $(node -v);
    else
      nvm use default;
    fi
  fi
}

