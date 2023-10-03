#!/usr/bin/env bash

# Download neovim tarball
curl -sfL -C - -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz

# Extract tarball
tar -xf nvim.tar.gz

# Update icon in desktop file
sed -i 's/Icon=nvim/Icon=\/opt\/nvim\/share\/icons\/hicolor\/128x128\/apps\/nvim.png/g' nvim-linux64/share/applications/nvim.desktop

# Move to /opt
sudo mv nvim-linux64 /opt/nvim

# Create symlink for nvim
sudo ln -s /opt/nvim/bin/nvim /usr/bin/nvim

# Create symlink for nvim manpage
sudo ln -s /opt/nvim/man/man1/nvim.1 /usr/share/man/man1/nvim.1

# Create symlink for nvim desktop
sudo ln -s /opt/nvim/share/applications/nvim.desktop /usr/share/applications/nvim.desktop

# Clean up
rm nvim.tar.gz

# Add nvimrc
mkdir -p ~/.config/nvim
cp config/nvim/init.vim ~/.config/nvim/init.vim
