#!/usr/bin/env bash

# Install homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set homebrew path
echo -e "\n# Set PATH for Homebrew" >> $HOME/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
source $HOME/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install ansible
ansible-playbook setup.yml

# Switch to zsh
zsh

echo "**** Don't forget to source bash profile ****"

