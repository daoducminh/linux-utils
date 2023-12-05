#!/usr/bin/env bash

# Download neovim tarball
curl -sfL -C - -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz

# Extract tarball
tar -xf nvim.tar.gz

# Update icon in desktop file
sed -i 's/Icon=nvim/Icon=\/opt\/nvim\/share\/icons\/hicolor\/128x128\/apps\/nvim.png/g' nvim-linux64/share/applications/nvim.desktop

# Copy and replace
sudo cp -rf nvim-linux64/* /opt/nvim/

# Clean up
rm nvim.tar.gz
rm -rf nvim-linux64
