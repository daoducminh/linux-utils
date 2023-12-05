#!/usr/bin/env bash

cd ~/Projects/alacritty

git pull
git checkout $1

cargo build --release

sudo cp -f target/release/alacritty /usr/local/bin
sudo cp -f extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
