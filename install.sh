#!/bin/bash

DESTINATION_DIRECTORY="/opt/nvim"
REPOSITORY_URL="https://github.com/jaideep-recruitcrm/cli-god.git"
TEMPORARY_DIRECTORY=$(mktemp -d)

function clean_existing {
  rm -rf ~/.config/tmux
  rm -rf ~/.config/nvim
  sudo rm -rf $DESTINATION_DIRECTORY
}

if [ -d "$DESTINATION_DIRECTORY" ]; then
  clean_existing
fi

echo ""
echo "INSTALLING PRE-REQUISITS"
(
  export DEBIAN_FRONTEND=noninteractive
  sudo apt update
  sudo apt install -y build-essential
)

echo ""
echo "CLONING REPOSITORY: $TEMPORARY_DIRECTORY"
git clone $REPOSITORY_URL $TEMPORARY_DIRECTORY
mkdir -p ~/.config/nvim
mkdir -p ~/.config/tmux
cp -r $TEMPORARY_DIRECTORY/nvim/* ~/.config/nvim
cp -r $TEMPORARY_DIRECTORY/tmux/* ~/.config/tmux
rm -rf $TEMPORARY_DIRECTORY

echo ""
echo "INSTALLING NEOVIM"
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz -o nvim-linux64.tar.gz
sudo tar -xzf nvim-linux64.tar.gz -C /opt/
rm -rf nvim-linux64.tar.gz
sudo mv /opt/nvim-linux64 $DESTINATION_DIRECTORY

echo ""
echo "INSTALLING TPM"
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

echo ""
echo "UPDATING ~/.bashrc"
if ! grep -q "NVIM_HOME" ~/.bashrc; then
  echo "NVIM_HOME=$DESTINATION_DIRECTORY" >> ~/.bashrc
fi

if ! grep -q "PATH=\"\$PATH:$NVIM_HOME/bin\"" ~/.bashrc; then
  echo 'PATH="$PATH:$NVIM_HOME/bin"' >> ~/.bashrc
fi

source ~/.bashrc

echo ""
echo "INSTALLATION COMPLETE"