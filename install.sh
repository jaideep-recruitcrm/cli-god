#!/bin/bash

DESTINATION_DIRECTORY="/opt/nvim"
REPOSITORY_URL="https://github.com/jaideep-recruitcrm/cli-god.git"
TEMPORARY_DIRECTORY=$(mktemp -d)

echo "Cloning Repository Temporarily"
git clone $REPOSITORY_URL $TEMPORARY_DIRECTORY

# Ensure the .config directory and its subdirectories exist
mkdir -p /home/ubuntu/.config/nvim
mkdir -p /home/ubuntu/.config/tmux

echo "Downloading NeoVim"
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz -o nvim-linux64.tar.gz

echo "Downloading TPM"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Package Manager Detection and Installation of TMUX and GCC
if command -v apt > /dev/null; then
    echo "Using apt to install TMUX and GCC"
    sudo apt update
    sudo apt install -y tmux gcc
elif command -v yum > /dev/null; then
    echo "Using yum to install TMUX and GCC"
    sudo yum install -y tmux gcc
else
    echo "No suitable package manager found (apt or yum). Exiting."
    exit 1
fi

# Copy the configuration files from the repository
cp -r $TEMPORARY_DIRECTORY/nvim/* /home/ubuntu/.config/nvim
cp -r $TEMPORARY_DIRECTORY/tmux/* /home/ubuntu/.config/tmux

# Clean up the temporary directory
rm -rf $TEMPORARY_DIRECTORY

echo "Extracting NeoVim to /opt/"
sudo tar -xvzf nvim-linux64.tar.gz -C /opt/
rm nvim-linux64.tar.gz

echo "Renaming extracted folder"
sudo mv /opt/nvim-linux64 $DESTINATION_DIRECTORY

echo "Updating .bashrc"
if ! grep -q 'export NVIM_HOME=$DESTINATION_DIRECTORY' ~/.bashrc; then
    echo "export NVIM_HOME=$DESTINATION_DIRECTORY" >> ~/.bashrc
fi
if ! grep -q 'export PATH="$PATH:$NVIM_HOME/bin"' ~/.bashrc; then
    echo 'export PATH="$PATH:$NVIM_HOME/bin"' >> ~/.bashrc
fi

echo "INSTALLATION COMPLETE"
