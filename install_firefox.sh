#!/usr/bin/env bash

curl -L -o firefox.tar.bz2 https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US

tar xf firefox.tar.bz2

sudo mv firefox /opt/firefox

sudo ln -s /opt/firefox/firefox /usr/bin/firefox

wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop && sudo mv firefox.desktop /usr/share/applications

rm firefox.tar.bz2
