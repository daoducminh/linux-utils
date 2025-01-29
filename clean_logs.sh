#!/usr/bin/env bash

rm /var/log/*.gz
rm /var/log/*.log.*
rm /var/log/*.0
rm /var/log/*.1

rm /var/log/apt/*.gz
rm /var/log/unattended-upgrades/*.gz

rm /var/log/cups/*.gz

rm /var/log/postgresql/*.gz
