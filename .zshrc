export NVM_COMPLETION=true
export DEFAULT_AVD='Pixel_2_API_26'

# Set default user
# Will show server named if SSH'd
[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="blake"

ZSH_THEME="dieter"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_TITLE="true"
HIST_STAMPS="mm/dd/yyyy"

# zsh plugins
plugins=(
  git
  osx
  gulp
  jsontools
  npm
  zsh-autosuggestions
  autojump
  nvm
)

source $ZSH/oh-my-zsh.sh

# launches the optionally specified AVD
# With no argument, it will use $DEFAULT_AVD or the first available AVD
# e.g.: LaunchAvdForeground Nexus_5X_API_23
function LaunchAvdForeground {
  local avdName=${1:-$DEFAULT_AVD}
  echo "Launching AVD: $avdName"
  $ANDROID_HOME/emulator/emulator -netdelay none -netspeed full -avd $avdName
}

# Removes merged git branches
function gcmb {
  git branch --merged | grep -Ev '^(\*|  master$)' | xargs git branch -d ;
}

find-up () {
  path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

cdnvm(){
  cd "$@";
  nvm_path=$(find-up .nvmrc | tr -d '[:space:]')

  # If there are no .nvmrc file, use the default nvm version
  if [[ ! $nvm_path = *[^[:space:]]* ]]; then
    declare default_version;
    default_version=$(nvm version default);

    # If there is no default version, set it to `node`
    # This will use the latest version on your machine
    if [[ $default_version == "N/A" ]]; then
      nvm alias default node;
      default_version=$(nvm version default);
    fi

    # If the current version is not the default version, set it to use the default version
    if [[ $(nvm current) != "$default_version" ]]; then
      nvm use default;
    fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
    declare nvm_version
    nvm_version=$(<"$nvm_path"/.nvmrc)

    declare locally_resolved_nvm_version
    # `nvm ls` will check all locally-available versions
    # If there are multiple matching versions, take the latest one
    # Remove the `->` and `*` characters and spaces
    # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
    locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

    # If it is not already installed, install it
    # `nvm install` will implicitly use the newly-installed version
    if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
      nvm install "$nvm_version";
    elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
      nvm use "$nvm_version";
    fi
  fi
}

# aliases
# os
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias cd='cdnvm'

# browser
alias devChrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_session" --disable-web-security'

# docker / kubernetes
alias dc="docker-compose"
alias ku="kubectl"

# react native
alias rn="react-native"
alias rproxy='adb reverse tcp:9090 tcp:9090'
alias rnlogcat='adb logcat *:S ReactNative:V ReactNativeJS:V'

# git
alias gco='git checkout'
alias git='hub'

# vim
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi