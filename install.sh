#!/bin/bash
TMP_URL="https://github.com/tmux-plugins/tpm"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip"
REPOSITORY_URL="https://github.com/jaideep-recruitcrm/cli-god.git"
DESTINATION_DIRECTORY="/opt/nvim"

if [ -d "$DESTINATION_DIRECTORY" ]; then
  rm -rf ~/.config/tmux
  rm -rf ~/.config/nvim
  sudo rm -rf $DESTINATION_DIRECTORY
fi

echo ""
echo "INSTALLING PRE-REQUISITS"
if [ -x "$(command -v yum)" ]; then
  sudo yum update &> /dev/null
  sudo yum install -y git &> /dev/null
  sudo yum install -y tmux &> /dev/null
  sudo yum groupinstall "Development Tools" &> /dev/null
elif [ -x "$(command -v apt)" ]; then
  sudo apt update &> /dev/null
  sudo apt install -y build-essential &> /dev/null
  sudo apt install -y ripgrep &> /dev/null
else
  echo "ERROR: No supported package manager found"
  exit 1
fi

echo ""
echo "CLONING REPOSITORY"
git clone $REPOSITORY_URL
mkdir -p ~/.config/nvim
mkdir -p ~/.config/tmux
cp -r cli-god/nvim/* ~/.config/nvim
cp -r cli-god/tmux/* ~/.config/tmux
rm -rf cli-god

echo ""
echo "INSTALLING NEOVIM"
curl -L "$NEOVIM_URL" -o nvim-linux64.tar.gz
sudo tar -xzf nvim-linux64.tar.gz -C /opt/
rm -rf nvim-linux64.tar.gz
sudo mv /opt/nvim-linux64 $DESTINATION_DIRECTORY

echo ""
echo "INSTALLING TPM"
git clone "$TMP_URL" ~/.config/tmux/plugins/tpm

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
