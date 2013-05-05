#!/bin/bash
sudo apt-get update
sudo apt-get -y install git ruby1.9.1 ruby1.9.1-dev build-essential
sudo gem install chef --no-ri --no-rdoc
git clone https://github.com/anthroprose/rpi-mesh.git ./rpi-mesh
cd rpi-mesh
echo "Please edit the file at ./chef-repo/data_bags/rpi-mesh/config.json"
