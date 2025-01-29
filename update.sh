#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

python3 -m pip install pip virtualenv rope faker requests lxml chardet urllib3 scrapy psycopg2-binary pre-commit -U

sudo snap refresh

LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

clear

