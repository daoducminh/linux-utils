#!/usr/bin/env bash

CUR_DIR=$PWD

# Update and upgrade
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common apt-transport-https wget ca-certificates curl gnupg-agent lsb-release -y

# Sublime Text 4
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Fish shell
sudo add-apt-repository ppa:fish-shell/release-3 -y

# Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# SafeEyes
sudo add-apt-repository ppa:slgobinath/safeeyes -y

# Grub-customizer
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

# Git
sudo add-apt-repository ppa:git-core/ppa -y

# ibus bamboo
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo

# Install all
sudo apt update
sudo apt install -y --install-recommends \
    curl wget \
    git \
    tmux \
    fish \
    unzip \
    ffmpeg \
    task-spooler \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    goldendict \
    python3-pip python3-dev \
    safeeyes \
    build-essential \
    gnome-tweaks \
    sublime-text sublime-merge \
    libcanberra-gtk-module libcanberra-gtk3-module \
    default-jdk \
    gnome-shell-extensions gnome-shell-extension-manager \
    ibus ibus-bamboo

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
    numpy \
    matplotlib \
    pandas \
    scrapy \
    itemloaders \
    pillow \
    rope \
    faker \
    sqlalchemy \
    psycopg2-binary

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

# Autoremove
sudo apt autoremove -y

# Snap install
sudo snap refresh

# Copy .bashrc
cd $CUR_DIR
cat config/bash/bashrc >>~/.bashrc
