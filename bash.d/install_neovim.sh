#!/bin/bash

install_neovim(){
  local usage="install_neovim

Options:
  -l, --list    List available versions
  -i VERSION    Install Neovim version
"
  source parseargs.sh
  parseargs "$usage" "$@" || return
  if [ -n "$LIST" ]; then
    curl -s https://api.github.com/repos/neovim/neovim/releases | jq ".[].tag_name" | tr -d '"'
  elif [ -n "$VERSION" ]; then
    echo "Installing NVIM $VERSION"
    curl -L "https://github.com/neovim/neovim/releases/download/$VERSION/nvim.appimage" -o nvim.appimage
    chmod +x nvim.appimage
    mv nvim.appimage ~/bin/nvim
    echo -n "Installed "
    ~/bin/nvim --version | head -n 1
  else
    echo "Usage: $usage"
    return 1
  fi
}
export install_neovim