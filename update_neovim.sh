#!/usr/bin/env bash

# Download neovim tarball
curl -sfL -C - -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz

# Extract tarball
tar -xf nvim.tar.gz

# Copy and replace
sudo cp -rf nvim-linux64/* /opt/nvim/

# Clean up
rm nvim.tar.gz
rm -rf nvim-linux64
