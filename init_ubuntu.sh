#!/usr/bin/env bash

CUR_DIR=$PWD

# Init project folder
mkdir -p ~/Projects

# Update and upgrade
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common apt-transport-https wget ca-certificates curl gnupg-agent lsb-release -y

# Sublime Text 4
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Fish shell
sudo add-apt-repository ppa:fish-shell/release-3 -y

# NodeJS 18.x
curl -sL "https://deb.nodesource.com/setup_18.x" | sudo -E bash -

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# MongoDB
# wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# SafeEyes
sudo add-apt-repository ppa:slgobinath/safeeyes -y

# Grub-customizer
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

# Git
sudo add-apt-repository ppa:git-core/ppa -y

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# oh-my-posh themes
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
# Override theme file
cp -f config/jblab_2021.omp.json ~/.poshthemes/jblab_2021.omp.json

# Vim 9
sudo add-apt-repository ppa:jonathonf/vim -y

# ibus bamboo
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo

# Install all
sudo apt update
sudo apt install -y --install-recommends \
    git \
    tmux \
    vim \
    fish \
    unzip \
    ffmpeg \
    task-spooler \
    nodejs \
    docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    goldendict \
    python3-pip python3-dev \
    safeeyes \
    build-essential \
    gnome-tweaks \
    sublime-text sublime-merge \
    yarn \
    libcanberra-gtk-module libcanberra-gtk3-module \
    default-jdk openjdk-11-source \
    gnome-shell-extensions gnome-shell-extension-manager \
    ibus ibus-bamboo

# Install FiraCode Nerd Fonts
mkdir -p ~/.fonts ~/firacode
curl -o ~/firacode.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/latest/FiraCode.zip
unzip firacode.zip -d ~/firacode
cp -f ~/firacode/* ~/.fonts/
rm -rf ~/firacode firacode.zip

# Install FiraMono Nerd Fonts
mkdir -p ~/.fonts ~/firamono
curl -o ~/firamono.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/latest/FiraMono.zip
unzip firamono.zip -d ~/firamono
cp -f ~/firamono/* ~/.fonts/
rm -rf ~/firamono firamono.zip

# Remove font metadata
rm -rf ~/.fonts/*.txt ~/.fonts/readme*

# Load Flameshot's config
mkdir -p ~/.config/flameshot
cp -f config/flameshot.conf ~/.config/flameshot/flameshot.ini

# Set up fish
cd $CUR_DIR
mkdir -p ~/.config/fish/
cp -f config/fish/config.fish ~/.config/fish/config.fish

# Post installation for Docker
sudo usermod -aG docker $USER

# Change shell to fish
chsh -s $(which fish)

# Pip
python3 -m pip install -U \
    pip \
    pipx \
    numpy \
    matplotlib \
    pandas \
    scrapy \
    itemloaders \
    pillow \
    rope \
    black \
    faker \
    sqlalchemy \
    psycopg2-binary

python3 -m pipx ensurepath

# Poetry
pipx install poetry
poetry completions bash >>~/.bash_completion
poetry completions fish >~/.config/fish/completions/poetry.fish

# F12 Terminal
mkdir -p ~/.local/share/nautilus/scripts/
sudo printf "#\!/bin/bash\n\nalacritty" >~/.local/share/nautilus/scripts/Terminal
sudo printf "#\!/bin/bash\n\ncode ." >~/.local/share/nautilus/scripts/vscode
sudo chmod +x ~/.local/share/nautilus/scripts/Terminal
sudo chmod +x ~/.local/share/nautilus/scripts/vscode
nautilus -q
mkdir -p ~/.config/nautilus/
sudo echo "F12 Terminal" >~/.config/nautilus/scripts-accels
sudo echo "F3 vscode" >>~/.config/nautilus/scripts-accels

# Git config global
git config --global user.name "Minh Dao"
git config --global user.email "daoducminh1997@gmail.com"
git config --global init.defaultBranch main

# Bamboo config
ibus restart
env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" &&
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

# Install Postman from tar.gz
curl -o postman.tar.gz -L "https://dl.pstmn.io/download/latest/linux64"
tar -xzf postman.tar.gz
sudo rm -rf /opt/Postman
sudo mv Postman /opt/Postman
sudo ln -s /opt/Postman/Postman /usr/bin/postman

cat >~/.local/share/applications/Postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/app/Postman %U
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

rm postman.tar.gz

# Install FileZilla from tar.bz2
# curl -o filezilla.tar.bz2 -L "https://dl4.cdn.filezilla-project.org/client/FileZilla_3.60.2_x86_64-linux-gnu.tar.bz2?h=em6o9_gmiWVhQIOKSW6xJw&x=1659342878"
# tar -xjvf filezilla.tar.bz2
# sudo rm -rf /opt/FileZilla3
# sudo mv FileZilla3 /opt/FileZilla3
# sudo ln -sf /opt/FileZilla3/bin/filezilla /usr/bin/filezilla

# cat > ~/.local/share/applications/filezilla.desktop <<EOL
# [Desktop Entry]
# Name=FileZilla
# GenericName=FTP client
# GenericName[da]=FTP-klient
# GenericName[de]=FTP-Client
# GenericName[fr]=Client FTP
# Comment=Download and upload files via FTP, FTPS and SFTP
# Comment[da]=Download og upload filer via FTP, FTPS og SFTP
# Comment[de]=Dateien über FTP, FTPS und SFTP übertragen
# Comment[fr]=Transférer des fichiers via FTP, FTPS et SFTP
# Exec=filezilla
# Terminal=false
# Icon=/opt/FileZilla3/share/icons/hicolor/480x480/apps/filezilla.png
# Type=Application
# Categories=Network;FileTransfer;
# EOL

# rm filezilla.tar.bz2

# change default shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Primary><Super>s']"
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>t']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous "['<Super>F1']"
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Super>F2']"
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Super>F3']"

# disable default shortcuts
gsettings set org.gnome.shell.keybindings screenshot "[]"
gsettings set org.gnome.shell.keybindings screenshot-window "[]"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys help "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys screenreader "[]"
gsettings set org.gnome.mutter.wayland.keybindings restore-shortcuts "[]"

# init custom shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

# set shortcut for flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

# set shortcut for vscode
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'VSCode'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'code'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'Scroll_Lock'

# set shortcut for alacritty
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding 'Pause'

# Download Flameshot, Skype, VSCode, DBeaver, Mongo Compass
curl -o code.deb -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
curl -o flameshot.deb -L "https://github.com/flameshot-org/flameshot/releases/download/v12.1.0/flameshot-12.1.0-1.ubuntu-20.04.amd64.deb"
# curl -o skypeforlinux.deb -L "https://repo.skype.com/latest/skypeforlinux-64.deb"
curl -o compass.deb -L "https://downloads.mongodb.com/compass/mongodb-compass_1.39.4_amd64.deb"
curl -o mongosh.deb -L "https://downloads.mongodb.com/compass/mongodb-mongosh_1.10.6_amd64.deb"

sudo apt install -y \
    ./flameshot.deb \
    ./compass.deb \
    ./mongosh.deb \
    ./code.deb

rm *.deb

# Install Calibre 5.44.0 for Ubuntu 20.04
# wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin version=5.44.0

# Autoremove
sudo apt autoremove -y

# Snap install
sudo snap refresh
# sudo snap install intellij-idea-ultimate --channel=2021.1/stable --classic

# Scala
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d >cs && chmod +x cs && ./cs setup

# Add .vimrc
cd $CUR_DIR
cp -f config/vim/.vimrc ~/.vimrc

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Alacritty
cd ~/Projects
git clone https://github.com/alacritty/alacritty.git
cd alacritty
git checkout tags/v0.12.2
# Install the Rust compiler with rustup
rustup override set stable
rustup update stable
# Install dependencies
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev -y
# Build and install
cargo build --release
# Create desktop file
sudo cp -f target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp -f extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
# Add fish completion
mkdir -p ~/.config/fish/completions
cp extra/completions/alacritty.fish ~/.config/fish/completions

# Install Alacritty theme
cd ~/Projects
git clone https://github.com/alacritty/alacritty-theme.git
cd alacritty-theme

# Config Alacritty
cd $CUR_DIR
mkdir -p ~/.config/alacritty
cp -f config/alacritty.toml ~/.config/alacritty/alacritty.toml

# Copy .bashrc
cd $CUR_DIR
cp -f config/bashrc ~/.bashrc

# Install polars
python3 -m pip install -U polars
