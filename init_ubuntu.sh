#!/usr/bin/env bash

sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common apt-transport-https wget ca-certificates curl gnupg-agent lsb-release -y

# Sublime Text 3
# wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
# echo "deb https://download.sublimetext.com/apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Fish shell
sudo add-apt-repository ppa:fish-shell/release-3 -y

# NodeJS 18.x
curl -sL "https://deb.nodesource.com/setup_18.x" | sudo -E bash -

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Python
# sudo add-apt-repository ppa:deadsnakes/ppa -y

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

# CopyQ
sudo add-apt-repository ppa:hluk/copyq -y

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

# Install all
sudo apt update
sudo apt install -y \
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
    copyq \
    safeeyes \
    build-essential \
    gnome-tweaks \
    grub-customizer \
    yarn \
    libcanberra-gtk-module libcanberra-gtk3-module

# Install FiraCode Nerd Fonts
mkdir -p ~/.fonts ~/firacode
curl -o ~/firacode.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip firacode.zip -d ~/firacode
mv ~/firacode/"Fira Code Regular Nerd Font Complete.ttf" ~/.fonts/
rm firacode.zip
rm -rf ~/firacode

# Set up fish
mkdir -p ~/.config/fish/
cat >~/.config/fish/config.fish <<EOF
oh-my-posh init fish --config ~/.poshthemes/jblab_2021.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/jandedobbeleer.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/night-owl.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/cobalt2.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/mt.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/paradox.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/powerline.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/tonybaloney.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/amro.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/atomic.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/bubbles.omp.json | source
# oh-my-posh init fish --config ~/.poshthemes/fish.omp.json | source

set -U fish_greeting Howdy, \$USER
EOF

# Post installation for Docker
sudo usermod -aG docker $USER

# Change shell to fish
chsh -s $(which fish)

# Pip
python3 -m pip install -U \
    pip \
    virtualenv \
    numpy \
    matplotlib \
    pandas \
    youtube-dl \
    scrapy \
    itemloaders \
    seaborn \
    pillow \
    autopep8 \
    pylint \
    rope \
    streamlit \
    faker \
    flask \
    sqlalchemy \
    psycopg2-binary

# F12 Terminal
mkdir -p ~/.local/share/nautilus/scripts/
sudo printf "#!/bin/sh\ngnome-terminal" >~/.local/share/nautilus/scripts/Terminal
sudo chmod +x Terminal
nautilus -q
mkdir -p ~/.config/nautilus/
sudo echo "F12 Terminal" >~/.config/nautilus/scripts-accels

# Git config global
git config --global user.name "Minh Dao"
git config --global user.email "daoducminh1997@gmail.com"

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
# Comment[de]=Dateien ??ber FTP, FTPS und SFTP ??bertragen
# Comment[fr]=Transf??rer des fichiers via FTP, FTPS et SFTP
# Exec=filezilla
# Terminal=false
# Icon=/opt/FileZilla3/share/icons/hicolor/480x480/apps/filezilla.png
# Type=Application
# Categories=Network;FileTransfer;
# EOL

# rm filezilla.tar.bz2

# Download Flameshot, Skype, VSCode, DBeaver, Mongo Compass
curl -o flameshot.deb -L "https://github.com/flameshot-org/flameshot/releases/download/v12.1.0/flameshot-12.1.0-1.ubuntu-20.04.amd64.deb"
curl -o skypeforlinux.deb -L "https://repo.skype.com/latest/skypeforlinux-64.deb"
curl -o code.deb -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
curl -o compass.deb -L "https://downloads.mongodb.com/compass/mongodb-compass_1.34.1_amd64.deb"
curl -o mongosh.deb -L "https://downloads.mongodb.com/compass/mongodb-mongosh_1.6.1_amd64.deb"

sudo apt install ./flameshot.deb \
    ./skypeforlinux.deb \
    ./compass.deb \
    ./mongosh.deb \
    ./code.deb \
    -y
rm *.deb

# Install Calibre 5.44.0 for Ubuntu 20.04
# wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin version=5.44.0

# Autoremove
sudo apt autoremove -y

# Snap install
sudo snap install vlc
sudo snap install intellij-idea-ultimate --channel=2021.1/stable --classic
