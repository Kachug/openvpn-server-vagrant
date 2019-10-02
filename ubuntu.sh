#!/usr/bin/env bash

# Update apt-get
apt-get -y update

# Update Ubuntu
apt-get -y upgrade
apt-get -o Dpkg::Options::='--force-confold' --force-yes -fuy dist-upgrade
0