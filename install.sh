#!/bin/bash

DESTINATION_DIRECTORY="/opt/nvim"
REPOSITORY_URL="https://github.com/jaideep-recruitcrm/cli-god.git"
TEMPORARY_DIRECTORY=$(mktemp -d)

echo ""
echo "Cloing Repository Temporarily"
git clone $REPOSITORY_URL $TEMPORARY_DIRECTORY

# echo ""
# echo "Downloading NeoVim"
# curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz -o nvim-linux64.tar.gz

# echo ""
# echo "Downloading TPM"
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone $REPOSITORY_URL $TEMPORARY_DIRECTORY

echo ""
echo "Installing TMUX"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [ "$ID" = "ubuntu" ] || [ "$ID" = "debian" ]; then
    sudo apt update
    sudo apt install -y tmux
    cp -r $TEMPORARY_DIRECTORY/nvim /home/ubuntu/.config/nvim
    cp -r $TEMPORARY_DIRECTORY/tmux ~/.config/tmux
  elif [ "$ID" = "amzn" ]; then
    sudo yum update
    sudo yum install -y tmux
    cp -r $TEMPORARY_DIRECTORY/nvim /home/ec2-user/.config/nvim
    cp -r $TEMPORARY_DIRECTORY/tmux /home/ec2-user/.config/tmux
  else
    echo "Unsupported OS: $ID"
    exit 1
  fi
else
  echo "Unable to detect OS"
  exit 1
fi
rm -rf $TEMPORARY_DIRECTORY

# echo ""
# echo "Extracting NeoVim to /opt/"
# sudo tar -xvzf nvim-linux64.tar.gz -C /opt/
# rm nvim-linux64.tar.gz

# echo ""
# echo "Renaming extracted folder"
# sudo mv /opt/nvim-linux64 $DESTINATION_DIRECTORY

# echo ""
# echo "Updating .bashrc"
# echo "export NVIM_HOME=$DESTINATION_DIRECTORY"
# echo 'export PATH="$PATH:$NVIM_HOME/bin"'
# source ~/.bashrc

# echo ""
# echo "INSTALLATION COMPLETE"
